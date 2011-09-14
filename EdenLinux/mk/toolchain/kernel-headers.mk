#mtl
${local_namespace("toolchain.kernel-headers")}

${package("$(TOOLCHAIN_BUILD_DIR)/torvalds-linux-fa9c4d0", "", "2.6.30", "linux-$(TOOLCHAIN_KERNEL-HEADERS_VERSION).tar.gz", "https://github.com/torvalds/linux/tarball/v2.6.30")}

#Special rule, while kernel.org is down
#${download}
$(DOWNLOAD_DIR)/v2.6.30:
	$(WGET) $(TOOLCHAIN_KERNEL-HEADERS_URL) -P $(DOWNLOAD_DIR)

$(DOWNLOAD_DIR)/$(TOOLCHAIN_KERNEL-HEADERS_FILE): $(DOWNLOAD_DIR)/v2.6.30
	$(CP) $(DOWNLOAD_DIR)/v2.6.30 $(DOWNLOAD_DIR)/$(${local}FILE)

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/Makefile")}

TOOLCHAIN_KERNEL-HEADERS_BUILD = $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/include/linux/version.h
$(TOOLCHAIN_KERNEL-HEADERS_BUILD): $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)/Makefile
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) mrproper
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) ARCH=$(KERNEL_ARCH) headers_check

TOOLCHAIN_KERNEL-HEADERS_INSTALL = $(ROOTFS_DIR)/usr/include/linux/fs.h 
$(TOOLCHAIN_KERNEL-HEADERS_INSTALL): $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/include/linux/version.h
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(ROOTFS_DIR)/usr headers_install

