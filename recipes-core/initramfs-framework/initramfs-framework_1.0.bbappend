SRC_URI:remove:tegra = "\
    file://0002-only-scan-for-block-devices.patch \
"

# List of modules to be added to initramfs image for each machine.
# Important: the order here matters, since the modules will be probed
# in the same order they are added to this variable!

# Modules necessary for our Verdin iMX8M(M|P) to display splash screen.
INITRAMFS_EXTRA_KMODS:append:mx8-nxp-bsp = "\
    fsl_imx_ldb \
    imx8mp_ldb \
    phy_fsl_imx8mp_lvds \
    irq_imx_irqsteer \
    sec_dsim \
    display_connector \
    sec_mipi_dsim_imx \
    ti_sn65dsi83 \
    lontium_lt8912b \
"

# Modules necessary for our Colibri iMX8X to display splash screen.
INITRAMFS_EXTRA_KMODS:append:colibri-imx8x = "\
    phy_mixel_lvds_combo \
    imx8qxp_ldb \
"

# On Toradex SMARC iMX8MP we need this extra module, before the rest of iMX8 modules
INITRAMFS_EXTRA_KMODS:prepend:toradex-smarc-imx8mp = "i2c_mux_pca954x "

# Modules necessary for our TI modules to display splash screen.
INITRAMFS_EXTRA_KMODS:append:ti-soc = "\
    pwm_tiehrpwm \
    tidss \
    display_connector \
    tc358768 \
    ti_sn65dsi83 \
    lontium_lt8912b \
"
# TI's AM62x/AM62P/AM62L Starter Kit EVMs use a SiI9022A bridge chip for
# HDMI, unlike our Verdin/Aquila carrier boards (which use lt8912b) - so
# this is only needed on the EVMs, not the whole ti-soc class.
INITRAMFS_EXTRA_KMODS:append:am62xx-evm = " sii902x"
INITRAMFS_EXTRA_KMODS:append:am62pxx-evm = " sii902x"
INITRAMFS_EXTRA_KMODS:append:am62lxx-evm = " sii902x"

# On BeagleY AI we need this extra module on top of TI modules
INITRAMFS_EXTRA_KMODS:append:beagley-ai = " ite_it66121"

# On Aquila AM69, we need this extra module to be loaded before the rest
# This is only needed when using at least V1.3 of the Aquila Development Board
INITRAMFS_EXTRA_KMODS:prepend:aquila-am69 = "i2c_mux_pca954x "

# Additional modules needed for splash screen on Aquila AM69
INITRAMFS_EXTRA_KMODS:append:aquila-am69 = "\
    cdns_dphy \
    cdns_dsi \
    cdns_mhdp8546 \
"

# Additional modules needed for splash screen on Verdin AM62P
INITRAMFS_EXTRA_KMODS:append:verdin-am62p = "\
    cdns_dphy \
    cdns_dsi \
"

# Modules necessary for our i.MX93 SoMs to display splash screen.
# The DSI connector I2C buses sit behind a PCA954x I2C mux, and the
# bridges come before the DSI host so it finds them on its first probe.
INITRAMFS_EXTRA_KMODS:append:mx93-nxp-bsp:tdx = "\
    i2c_mux_pca954x \
    phy_fsl_imx93_mipi_dphy \
    pwm_imx_tpm \
    phy_fsl_imx8mp_lvds \
    fsl_imx_ldb \
    imx93_ldb \
    display_connector \
    ti_sn65dsi83 \
    lontium_lt8912b \
    dw_mipi_dsi \
    dw_mipi_dsi_imx \
"

# Modules necessary for our i.MX95 SoMs to display splash screen.
INITRAMFS_EXTRA_KMODS:append:mx95-nxp-bsp = "\
    phy_fsl_imx8mp_lvds \
    pwm_imx_tpm \
    imx95_ldb \
    imx_ldb_helper \
    ti_sn65dsi83 \
    imx95_dpu_drm \
    lontium_lt8912b \
    irq_imx_irqsteer \
    imx95_pixel_link \
    imx95_pixel_interleaver \
    imx95_mipi_dsi \
    dw_mipi_dsi \
    display_connector \
"
