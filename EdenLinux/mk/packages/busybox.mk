#mtl
${local_namespace("packages.busybox")}

${package("$(PACKAGES_BUILD_DIR)/busybox-$(PACKAGES_BUSYBOX_VERSION)", "", "1.18.4", "busybox-$(PACKAGES_BUSYBOX_VERSION).tar.bz2", "http://busybox.net/downloads/$(PACKAGES_BUSYBOX_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_BUSYBOX_SRC_DIR)/Makefile")}

${local}CONFIG := $(PACKAGES_BUSYBOX_SRC_DIR)/.config
$(PACKAGES_BUSYBOX_CONFIG): $(TARGET_BUSYBOX_CONFIG) $(PACKAGES_BUSYBOX_SRC_DIR)/Makefile
	$(CP) -a $(TARGET_BUSYBOX_CONFIG) $(PACKAGES_BUSYBOX_SRC_DIR)/.config
	$(TOOLCHAIN_ENV) $(MAKE) -C $(PACKAGES_BUSYBOX_SRC_DIR) oldconfig

${local}DEPMOD := $(ROOTFS_DIR)/sbin/depmod.pl
$(PACKAGES_BUSYBOX_DEPMOD): $(PACKAGES_BUSYBOX_SRC_DIR)/Makefile
	$(CP) "$(PACKAGES_BUSYBOX_SRC_DIR)/examples/depmod.pl" $(PACKAGES_BUSYBOX_DEPMOD)
	
${make("$(TOOLCHAIN_ENV)", 'ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc"', "all", "$(PACKAGES_BUSYBOX_SRC_DIR)/busybox", "$(PACKAGES_BUSYBOX_CONFIG)")}

${make("$(TOOLCHAIN_ENV)", 'ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc"  CONFIG_PREFIX=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/bin/busybox", "$(PACKAGES_BUSYBOX_CONFIG)")}
	
$(ROOTFS_DIR)/etc/network/udhcpc.script:
	$(CP) $(ROOT)/${put(namespace.current.replace(".", "/"))}/udhcpc-default.script $(ROOTFS_DIR)/etc/network/udhcpc.script
