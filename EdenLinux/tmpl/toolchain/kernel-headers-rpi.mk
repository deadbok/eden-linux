#mtl
${local_namespace("toolchain.kernel-headers-rpi")}

${Package('$(TOOLCHAIN_BUILD_DIR)/linux-$(TOOLCHAIN_KERNEL-HEADERS-RPI_VERSION)', '', '3.10.y', "https://github.com/raspberrypi/linux.git", "$(ROOTFS_DIR)/usr/include/linux/fs.h")}

${Rule('$(DOWNLOAD_DIR)/linux/README', rule_var_name=var_name("clone"))}
	$(MKDIR) $(DOWNLOAD_DIR)/linux
	$(GIT) clone --depth=1 $(TOOLCHAIN_KERNEL-HEADERS-RPI_URL) $(DOWNLOAD_DIR)/linux
	$(CD) $(DOWNLOAD_DIR)/linux; $(GIT) checkout rpi-$(TOOLCHAIN_KERNEL-HEADERS-RPI_VERSION); 

${Rule('$(TEMP_DIR)/.kernel-rpi-download', "$(TOOLCHAIN_KERNEL-HEADERS-RPI_CLONE)", rule_var_name=var_name("download"))}
	$(CP) -R $(DOWNLOAD_DIR)/linux $(TOOLCHAIN_KERNEL-HEADERS-RPI_SRC_DIR)
	$(TOUCH) $@
	
${Rule('$(TOOLCHAIN_KERNEL-HEADERS-RPI_SRC_DIR)/include/generated/uapi/linux/version.h', "$(TOOLCHAIN_KERNEL-HEADERS-RPI_DOWNLOAD)", rule_var_name=var_name("build"))}
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS-RPI_BUILD_DIR) mrproper
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS-RPI_BUILD_DIR) ARCH=$(KERNEL_ARCH) headers_check

${MakeRule('CFLAGS="" CXXFLAGS=""', 'ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(ROOTFS_DIR)/usr', "$(TOOLCHAIN_KERNEL-HEADERS-RPI_BUILD_DIR)", "headers_install", "$(ROOTFS_DIR)/usr/include/linux/fs.h", "$(TOOLCHAIN_KERNEL-HEADERS-RPI_BUILD)", var_name("install"))}

.NOTPARALLEL: