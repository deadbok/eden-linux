#mtl
${local_namespace("packages.boot-config.rpi")}

#Package to instaææ cmdline.txt and config.txt to the boot directory
${Package("$(ROOT)/target/config/rpi/packages/boot-config", "", "1.0", "", "$(ROOTFS_DIR)/boot/config.txt")}

${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BOOT-CONFIG_RPI_BUILD_DIR)", "install", "$(ROOTFS_DIR)/boot/config.txt", rule_var_name = var_name("install"))} 

PACKAGES_BOARD_INSTALL += $(PACKAGES_BOOT-CONFIG_RPI_INSTALL)

.NOTPARALLEL: