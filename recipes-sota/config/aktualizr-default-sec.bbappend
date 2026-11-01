FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

require recipes-bsp/u-boot/u-boot-fusing.inc

SRC_URI:append = " \
    file://bl_actions.sh \
    file://common_actions.sh \
    file://fuse_actions-in.sh \
    "

# Only i.MX machines have registered fuses; an unlisted i.MX machine must choose explicitly.
TORIZON_SECONDARY_FUSES_DEFAULT ??= "${@'' if 'imx-generic-bsp' in \
                                  d.getVar('MACHINEOVERRIDES').split(':') else '0'}"

BOOTLOADER_ACTION_HANDLER_TYPE ?= "${BOOTLOADER_ACTION_HANDLER_TYPE_DEFAULT}"
BOOTLOADER_ACTION_HANDLER_TYPE_DEFAULT ??= "dummy"
BOOTLOADER_ACTION_HANDLER = "${@'bl_actions.sh' \
    if d.getVar('BOOTLOADER_ACTION_HANDLER_TYPE') == 'uboot-emmc' else 'dummy_actions.sh'}"

# Keep the ECU when uEnv.txt cannot program fuses, but refuse updates through the dummy.
FUSE_ACTION_HANDLER = "${@'fuse_actions.sh' \
    if d.getVar('FUSE_SUPPORT') == '1' and d.getVar('FUSE_SUPPORT_TYPE') == 'NXP' \
    else 'dummy_actions.sh'}"

def torizon_secondary_rdepends(d):
    real_bootloader = (
        d.getVar('TORIZON_SECONDARY_BOOTLOADER') == '1'
        and d.getVar('BOOTLOADER_ACTION_HANDLER') == 'bl_actions.sh'
    )
    real_fuses = (
        d.getVar('TORIZON_SECONDARY_FUSES') == '1'
        and d.getVar('FUSE_ACTION_HANDLER') == 'fuse_actions.sh'
    )

    dependencies = []
    if real_bootloader:
        dependencies.extend(['jq', 'util-linux', 'mmc-utils'])
    if real_bootloader or real_fuses:
        dependencies.extend(['bash', 'coreutils', 'sed', 'u-boot-fw-utils'])

    return ' '.join(dependencies)

RDEPENDS:${PN}:append = " ${@torizon_secondary_rdepends(d)}"

python () {
    handler_type = d.getVar('BOOTLOADER_ACTION_HANDLER_TYPE')
    if handler_type not in ('dummy', 'uboot-emmc'):
        bb.fatal(
            'BOOTLOADER_ACTION_HANDLER_TYPE is "%s" for MACHINE "%s". It must be "dummy" (the '
            'bootloader secondary refuses updates) or "uboot-emmc" (bl_actions.sh, for U-Boot in '
            'the eMMC hardware boot partitions).' % (handler_type, d.getVar('MACHINE')))
}

do_install:append () {
    needs_common=0
    if [ "${TORIZON_SECONDARY_BOOTLOADER}" = "1" ] && \
       [ "${BOOTLOADER_ACTION_HANDLER}" = "bl_actions.sh" ]; then
        install -d ${D}${bindir}
        install -m 0744 ${UNPACKDIR}/bl_actions.sh ${D}${bindir}/bl_actions.sh
        needs_common=1
    fi
    if [ "${TORIZON_SECONDARY_FUSES}" = "1" ] && \
       [ "${FUSE_ACTION_HANDLER}" = "fuse_actions.sh" ]; then
        install -d ${D}${bindir}
        sed -e 's/@@MACHINE@@/${MACHINE}/' \
            ${UNPACKDIR}/fuse_actions-in.sh > ${UNPACKDIR}/fuse_actions.sh
        install -m 0744 ${UNPACKDIR}/fuse_actions.sh ${D}${bindir}/fuse_actions.sh
        needs_common=1
    fi
    if [ "$needs_common" = "1" ]; then
        install -m 0644 ${UNPACKDIR}/common_actions.sh ${D}${bindir}/common_actions.sh
    fi
}

FILES:${PN}:append = " ${bindir}/common_actions.sh"
