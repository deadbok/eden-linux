#mtl
${local_namespace("packages.busybox")}

${Package("$(PACKAGES_BUILD_DIR)/busybox-$(PACKAGES_BUSYBOX_VERSION)", "", "1.19.3", "http://busybox.net/downloads/busybox-$(PACKAGES_BUSYBOX_VERSION).tar.bz2", "$(ROOTFS_DIR)/bin/busybox")}

${DownloadRule("$(PACKAGES_BUSYBOX_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(PACKAGES_BUSYBOX_FILE)", "$(PACKAGES_BUILD_DIR)", "$(PACKAGES_BUSYBOX_SRC_DIR)/Makefile")}

${local()}CONFIG := $(PACKAGES_BUSYBOX_BUILD_DIR)/.config
$(PACKAGES_BUSYBOX_CONFIG): $(PACKAGES_BUSYBOX_SRC_DIR)/Makefile $(TARGET_BUSYBOX_CONFIG) 	
	$(CP) -a $(TARGET_BUSYBOX_CONFIG) $(PACKAGES_BUSYBOX_BUILD_DIR)/.config
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_BUSYBOX_BUILD_DIR) oldconfig

${local()}DEPMOD := $(ROOTFS_DIR)/sbin/depmod.pl
$(PACKAGES_BUSYBOX_DEPMOD): $(PACKAGES_BUSYBOX_SRC_DIR)/Makefile
	$(CP) "$(PACKAGES_BUSYBOX_SRC_DIR)/examples/depmod.pl" $(PACKAGES_BUSYBOX_DEPMOD)

${MakeRule("$(PACKAGES_ENV)", 'ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc"', "$(PACKAGES_BUSYBOX_BUILD_DIR)", "all", "$(PACKAGES_BUSYBOX_BUILD_DIR)/busybox", "$(PACKAGES_BUSYBOX_CONFIG)", var_name("build"))}	

${Rule('$(ROOTFS_DIR)/etc/network/udhcpc.script', rule_var_name=var_name("udhcpc-script"))}
	-$(MKDIR) $(ROOTFS_DIR)/etc/network
	$(CP) $(PACKAGES_BUSYBOX_SRC_DIR)/examples/udhcp/simple.script $(ROOTFS_DIR)/etc/network/udhcpc.script

${MakeRule("$(PACKAGES_ENV)", 'ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_PREFIX=$(ROOTFS_DIR)', "$(PACKAGES_BUSYBOX_BUILD_DIR)", "install", "$(ROOTFS_DIR)/bin/busybox", "$(PACKAGES_BUSYBOX_BUILD) $(PACKAGES_BUSYBOX_UDHCPC-SCRIPT)", var_name("install"))}

busybox-menuconfig:
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_BUSYBOX_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)-  CC="$(ARCH_TARGET)-gcc" menuconfig
	
	
.NOTPARALLEL: