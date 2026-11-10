# Shared Torizon <-> Qualcomm BSP integration glue for machines based on
# meta-qcom (Qualcomm Dragonwing / Linux reference BSP).
#
# Boot flow on these machines: XBL -> UEFI (EDK2) -> systemd-boot -> UKI.
# There is no U-Boot. The OSTree side of it is provided by meta-updater's
# sota_qcom class, selected automatically by sota.bbclass for the "qcom"
# machine override: systemd-boot as OSTREE_BOOTLOADER, a UKI with an empty
# embedded command line, BLS entries written by OSTree with boot counting,
# and the "qcomflash" image that is flashed over EDL with qdl. Only the
# Torizon-specific glue lives here.

# --- Kernel command line ----------------------------------------------------
# With systemd-boot the BLS entries written by OSTree are the only source of
# the kernel command line (on U-Boot machines the boot script adds console=
# and root=). torizon.bbclass assigns OSTREE_KERNEL_ARGS with the splash
# arguments, which replaces sota_qcom's weak default and would leave the
# initramfs without root=. Prepend the same composition sota_qcom uses, so
# the command line carries both the BSP arguments (serial console from
# SERIAL_CONSOLES, root=, SoC-specific KERNEL_CMDLINE_EXTRA) and the Torizon
# splash arguments.
OSTREE_KERNEL_ARGS:prepend = "console=${KERNEL_CONSOLE} ${OSTREE_KERNEL_ARGS_COMMON} ${KERNEL_CMDLINE_EXTRA} "

# --- OTA / bootloader environment -------------------------------------------
# No U-Boot environment exists on these machines: rollback relies on
# systemd-boot boot counting instead.
SOTA_CLIENT_FEATURES:remove = "ubootenv"
