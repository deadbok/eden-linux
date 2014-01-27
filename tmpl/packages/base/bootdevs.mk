#mtl
${local_namespace("packages.base.bootdevs")}

${Package("$(PACKAGES_BASE_FILE_DIR)/bootdevs", "", "1.0", "", "$(ROOTFS_DIR)/.devs")}

${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BASE_BOOTDEVS_BUILD_DIR)", "install", "$(ROOTFS_DIR)/.dev", "", var_name("install"), True)} 

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_BOOTDEVS_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: