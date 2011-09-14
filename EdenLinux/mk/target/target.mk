#mtl
${local_namespace("target")}

${local}PROCESSOR = i686
${local}IMAGE_TYPE = vmware
${local}FILE_SYSTEM = iso
${local}UCLIBC_CONFIG = $(ROOT)/target/x86/uclibc_config
${local}KERNEL_CONFIG = $(ROOT)/target/x86/kernel_config
${local}BUSYBOX_CONFIG = $(ROOT)/target/x86/busybox_config

update-configs: $(${local}UCLIBC_CONFIG)

$(${local}UCLIBC_CONFIG): $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config
	$(CP) -a $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config $(${local}UCLIBC_CONFIG)
	
$(${local}KERNEL_CONFIG): $(PACKAGES_KERNEL_SRC_DIR)/.config
	$(CP) -a $(PACKAGES_KERNEL_SRC_DIR)/.config $(${local}KERNEL_CONFIG)
	
$(${local}BUSYBOX_CONFIG): $(PACKAGES_BUSYBOX_SRC_DIR)/.config
	$(CP) -a $(PACKAGES_BUSYBOX_SRC_DIR)/.config $(${local}BUSYBOX_CONFIG)

#INSTALL = $(BUILD_ISO_TARGET)