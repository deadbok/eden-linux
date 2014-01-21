#mtl
${local_namespace("toolchain.kernel-headers")}

#Rpi kernel package
${Package('$(TOOLCHAIN_BUILD_DIR)/linux-$(TOOLCHAIN_KERNEL-HEADERS_VERSION)', '$(TOOLCHAIN_BUILD_DIR)/linux_build', '3.10.y', "https://github.com/raspberrypi/linux.git", "$(ROOTFS_DIR)/usr/include/linux/fs.h")}

#Clone git repositry
${Rule('$(DOWNLOAD_DIR)/linux/README', rule_var_name=var_name("clone"))}
	$(MKDIR) $(DOWNLOAD_DIR)/linux
	$(GIT) clone --depth=1 $(TOOLCHAIN_KERNEL-HEADERS_URL) $(DOWNLOAD_DIR)/linux
	$(CD) $(DOWNLOAD_DIR)/linux; $(GIT) checkout rpi-$(TOOLCHAIN_KERNEL-HEADERS_VERSION); 

#Link the sources
${Rule('$(TEMP_DIR)/.kernel-rpi-download', "$(TOOLCHAIN_KERNEL-HEADERS_CLONE)", rule_var_name=var_name("link-src"))}
	$(LN) -sf $(DOWNLOAD_DIR)/linux $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)
	$(TOUCH) $@

#House keeping
${Rule('$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)/include/generated/uapi/linux/version.h', "$(TOOLCHAIN_KERNEL-HEADERS_LINK-SRC)", rule_var_name=var_name("build"))}
	$(MKDIR) $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)
	KBUILD_OUTPUT=$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) mrproper
	KBUILD_OUTPUT=$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) ARCH=$(KERNEL_ARCH) headers_check

#Install headers
${MakeRule('KBUILD_OUTPUT=$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) CFLAGS="" CXXFLAGS=""', 'ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(ROOTFS_DIR)/usr', "$(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)", "headers_install", "$(ROOTFS_DIR)/usr/include/linux/fs.h", "$(TOOLCHAIN_KERNEL-HEADERS_BUILD)", var_name("install"))}

.NOTPARALLEL: