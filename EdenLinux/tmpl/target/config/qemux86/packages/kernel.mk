#mtl
${local_namespace("packages.kernel")}

${Package("$(PACKAGES_BUILD_DIR)/linux-$(PACKAGES_KERNEL_VERSION)", "", "3.10.27", "http://linux-kernel.uio.no/pub/linux/kernel/v3.0/linux-$(PACKAGES_KERNEL_VERSION).tar.xz", "$(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)")}

#Link sources 
${Rule('$(PACKAGES_KERNEL_SRC_DIR)/Makefile', "$(TOOLCHAIN_KERNEL-HEADERS_UNPACK)", rule_var_name=var_name("link-src"))}
	$(LN) -sf $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) $(PACKAGES_KERNEL_SRC_DIR)

#Clean sources and copy the config file into the build directory
${Rule('$(PACKAGES_KERNEL_BUILD_DIR)/.config', "$(TARGET_KERNEL_CONFIG)", rule_var_name=var_name("copy-config"))}
	$(MKDIR) $(PACKAGES_KERNEL_BUILD_DIR)
	KBUILD_OUTPUT=$(PACKAGES_KERNEL_BUILD_DIR) $(MAKE) -C $(PACKAGES_KERNEL_SRC_DIR) mrproper
	$(CP) -a $(TARGET_KERNEL_CONFIG) $(PACKAGES_KERNEL_BUILD_DIR)/.config

#Configure and build
${Rule('$(PACKAGES_KERNEL_BUILD_DIR)/arch/$(KERNEL_ARCH)/boot/bzImage', "$(PACKAGES_KERNEL_LINK-SRC) $(PACKAGES_KERNEL_COPY-CONFIG)", rule_var_name=var_name("build"))}
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- oldconfig
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)-

#Install kernel and modules int the rootfs	
${Rule('$(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)', "$(PACKAGES_KERNEL_BUILD) $(ROOTFS_DIR)/sbin/depmod.pl", rule_var_name=var_name("install"))}
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/System.map $(ROOTFS_DIR)/boot/System.map-$(PACKAGES_KERNEL_VERSION)
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/arch/$(KERNEL_ARCH)/boot/bzImage $(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/.config $(ROOTFS_DIR)/boot/config-$(PACKAGES_KERNEL_VERSION)
ifdef STRIP_TARGET	
	$(TOOLCHAIN_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- modules_install INSTALL_MOD_PATH=$(ROOTFS_DIR) INSTALL_MOD_STRIP=1
else
	$(TOOLCHAIN_ENV) $(MAKE) -$(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- modules_install INSTALL_MOD_PATH=$(ROOTFS_DIR)
endif
	$(ROOTFS_DIR)/sbin/depmod.pl -F $(ROOTFS_DIR)/boot/System.map-$(PACKAGES_KERNEL_VERSION) -b $(ROOTFS_DIR)/lib/modules/$(PACKAGES_KERNEL_VERSION)

kernel-menuconfig:
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- menuconfig

#Add kernel to target
PACKAGES_BOARD_BUILD += $(PACKAGES_KERNEL_BUILD)
PACKAGES_BOARD_INSTALL += $(PACKAGES_KERNEL_INSTALL)
PACKAGES_NAME_BOARD += ${namespace.current}

.NOTPARALLEL: