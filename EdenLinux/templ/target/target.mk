#mtl
${local_namespace("target")}

${local}PROCESSOR = i686
${local}IMAGE_TYPE = vmware
${local}FILE_SYSTEM = iso
${local}UCLIBC_CONFIG = $(ROOT)/target/x86/uclibc_config
${local}KERNEL_CONFIG = $(ROOT)/target/x86/kernel_config
${local}BUSYBOX_CONFIG = $(ROOT)/target/x86/busybox_config

#update-uclibc-config: $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config
#	$(CP) -a $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config $(${local}UCLIBC_CONFIG)
	
#update-kernel-config: $(PACKAGES_KERNEL_SRC_DIR)/.config
#	$(CP) -a $(PACKAGES_KERNEL_SRC_DIR)/.config $(${local}KERNEL_CONFIG)
	
#update-busybox-config: $(PACKAGES_BUSYBOX_SRC_DIR)/.config
#	$(CP) -a $(PACKAGES_BUSYBOX_SRC_DIR)/.config $(${local}BUSYBOX_CONFIG)

#INSTALL = $(BUILD_ISO_TARGET)