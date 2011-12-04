#mtl
${local_namespace("toolchain.kernel-headers")}

${Package('$(TOOLCHAIN_BUILD_DIR)/linux-$(TOOLCHAIN_KERNEL-HEADERS_VERSION)', '', '3.0.9', "http://linux-kernel.uio.no/pub/linux/kernel/v3.0/linux-$(TOOLCHAIN_KERNEL-HEADERS_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/include/linux/fs.h")}

${DownloadRule("$(TOOLCHAIN_KERNEL-HEADERS_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(TOOLCHAIN_KERNEL-HEADERS_FILE)", "$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)/Makefile")}

include packages/kernel-modules.mk

${Rule('$(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/include/linux/version.h', "$(TOOLCHAIN_KERNEL-HEADERS_UNPACK) $(PACKAGES_KERNEL_MODULES)", rule_var_name=var_name("build"))}
#TOOLCHAIN_KERNEL-HEADERS_BUILD = $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/include/linux/version.h
#$(TOOLCHAIN_KERNEL-HEADERS_BUILD):  $(TOOLCHAIN_KERNEL-HEADERS_UNPACK) $(PACKAGES_KERNEL_MODULES) 
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) mrproper
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) ARCH=$(KERNEL_ARCH) headers_check

#TOOLCHAIN_KERNEL-HEADERS_INSTALL = $(ROOTFS_DIR)/usr/include/linux/fs.h 
#$(TOOLCHAIN_KERNEL-HEADERS_INSTALL): $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/include/linux/version.h
${MakeRule('CFLAGS="" CXXFLAGS=""', 'ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(ROOTFS_DIR)/usr', "$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)", "headers_install", "$(ROOTFS_DIR)/usr/include/linux/fs.h", "$(TOOLCHAIN_KERNEL-HEADERS_BUILD)", var_name("install"))}
#	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(ROOTFS_DIR)/usr headers_install

.NOTPARALLEL: