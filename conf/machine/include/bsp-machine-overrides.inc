# Machine / SoC-family distro-config overrides shared by Torizon distro
# families.
#
# Default to "nxp": Toradex machines get their own IMX_DEFAULT_BSP from
# TDX_BSP_VARIANT (tdx-nxp-*.inc / tdx-upstream-mainline*.inc), and
# Common Torizon NXP machines have no such chain, so both need "nxp".
#
# TDX_BSP_VARIANT is checked directly rather than via a :upstream
# override (collides with torizon-upstream[-rt].conf's DISTROOVERRIDES
# flag) or MACHINEOVERRIDES (circular: it's partly derived from
# IMX_DEFAULT_BSP itself). The mainline values are an explicit list, not
# a prefix match, so adding a new variant is a deliberate edit here.
TDX_BSP_VARIANT_MAINLINE_VALUES = "tdx-upstream-mainline tdx-upstream-mainline-rt"
IMX_DEFAULT_BSP = "${@'mainline' if d.getVar('TDX_BSP_VARIANT') in d.getVar('TDX_BSP_VARIANT_MAINLINE_VALUES').split() else 'nxp'}"

IMAGE_BOOT_FILES_REMOVE:append:apalis-imx8 = " hdmitxfw.bin dpfw.bin"
IMAGE_CLASSES:append = " torizon-image-machine"

DISTRO_FEATURES_REMOVE:remove:verdin-imx95 = "vulkan"
DISTRO_FEATURES_REMOVE:remove:toradex-smarc-imx95 = "vulkan"
DISTRO_FEATURES_REMOVE:append:imx-generic-bsp = " opengl"

# No need for x11 even for native
DISTRO_FEATURES_NATIVE:remove:imx-generic-bsp = "x11"
DISTRO_FEATURES_NATIVESDK:remove:imx-generic-bsp = "x11"

TOS_SECBOOT_REQUIRED_BOOTARGS_DEFAULT:qemuarm64 ?= ""

# Cross machines / BSPs
## Drop IMX BSP that is not needed
MACHINE_EXTRA_RRECOMMENDS:remove:imx = "imx-alsa-plugins"

# Compatibility with Toradex BSP layers
BBMASK += " \
    /meta-freescale/recipes-graphics/cairo \
    /meta-imx/meta-imx-ml/recipes-bsp/ara2 \
"

require torizon-secondaries.inc

# Load Torizon-only BSP metadata after torizon.inc selects its distro family.
require ${@'bsp-machine-overrides-torizon.inc' if 'torizon-distro' in d.getVar('DISTROOVERRIDES').split(':') else ''}

# Common Torizon currently has no family-specific BSP overrides. Add a conditional require for bsp-machine-overrides-common-torizon.inc when needed.
# require ${@'bsp-machine-overrides-common-torizon.inc' if 'common-torizon-distro' in d.getVar('DISTROOVERRIDES').split(':') else ''}
