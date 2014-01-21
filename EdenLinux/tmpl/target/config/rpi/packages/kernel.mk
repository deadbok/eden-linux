#mtl
${local_namespace("packages.kernel")}

#Kernel package
${Package("$(PACKAGES_BUILD_DIR)/linux-$(PACKAGES_KERNEL_VERSION)", "$(PACKAGES_BUILD_DIR)/linux_build", "3.10.y", "https://github.com/raspberrypi/linux.git", "$(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)")}

#Link sources
${Rule('$(PACKAGES_KERNEL_SRC_DIR)/Makefile', "$(TOOLCHAIN_KERNEL-HEADERS-RPI_DOWNLOAD)", rule_var_name=var_name("link-src"))}
	$(LN) -sf $(DOWNLOAD_DIR)/linux $(PACKAGES_KERNEL_SRC_DIR)

#Clean sources and copy the config file into the build directory
${Rule('$(PACKAGES_KERNEL_BUILD_DIR)/.config', "$(TARGET_KERNEL_CONFIG)", rule_var_name=var_name("copy-config"))}
	$(MKDIR) $(PACKAGES_KERNEL_BUILD_DIR)
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(MAKE) -C $(PACKAGES_KERNEL_SRC_DIR) mrproper
	$(CP) -a $(TARGET_KERNEL_CONFIG) $(PACKAGES_KERNEL_BUILD_DIR)/.config

#Configure and build
${Rule('$(PACKAGES_KERNEL_BUILD_DIR)/arch/$(KERNEL_ARCH)/boot/Image', "$(PACKAGES_KERNEL_LINK-SRC) $(PACKAGES_KERNEL_COPY-CONFIG)", rule_var_name=var_name("build"))}
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(PACKAGES_ENV) KERNEL_SRC=$(PACKAGES_KERNEL_SRC_DIR) CCPREFIX=$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)- $(MAKE) -C $(PACKAGES_KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- oldconfig
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)-

#Install kernel and modules int the rootfs	
${Rule('$(ROOTFS_DIR)/boot/kernel.img', "$(PACKAGES_KERNEL_BUILD) $(ROOTFS_DIR)/sbin/depmod.pl", rule_var_name=var_name("install"))}
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/arch/$(KERNEL_ARCH)/boot/Image $(ROOTFS_DIR)/boot/kernel.img
ifdef STRIP_TARGET	
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(TOOLCHAIN_ENV) $(MAKE) -C $(PACKAGES_KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- modules_install INSTALL_MOD_PATH=$(ROOTFS_DIR) INSTALL_MOD_STRIP=1
else
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(TOOLCHAIN_ENV) $(MAKE) -C $(PACKAGES_KERNEL_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- modules_install INSTALL_MOD_PATH=$(ROOTFS_DIR)
endif
	$(ROOTFS_DIR)/sbin/depmod.pl -F $(PACKAGES_KERNEL_BUILD_DIR)/System.map -b $(ROOTFS_DIR)/lib/modules/$(RPI_KERNEL_VERSION)

#Run the menu configuration kernel
kernel-menuconfig:
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- menuconfig

PACKAGES_BOARD_BUILD += $(PACKAGES_KERNEL_BUILD)
PACKAGES_BOARD_INSTALL += $(PACKAGES_KERNEL_INSTALL)

.NOTPARALLEL: