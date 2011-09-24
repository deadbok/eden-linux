#mtl
${local_namespace("target")}


include target/iso.mk

#update-uclibc-config: $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config
#	$(CP) -a $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config $(${local}UCLIBC_CONFIG)
	
#update-kernel-config: $(PACKAGES_KERNEL_SRC_DIR)/.config
#	$(CP) -a $(PACKAGES_KERNEL_SRC_DIR)/.config $(${local}KERNEL_CONFIG)
	
#update-busybox-config: $(PACKAGES_BUSYBOX_SRC_DIR)/.config
#	$(CP) -a $(PACKAGES_BUSYBOX_SRC_DIR)/.config $(${local}BUSYBOX_CONFIG)

${local}INSTALL = $(TARGET_ISO_FILE)