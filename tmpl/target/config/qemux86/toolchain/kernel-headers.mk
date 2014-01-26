#mtl
${local_namespace("toolchain.kernel-headers")}

${Package('$(TOOLCHAIN_BUILD_DIR)/linux-$(TOOLCHAIN_KERNEL-HEADERS_VERSION)', '', '3.10.27', "http://linux-kernel.uio.no/pub/linux/kernel/v3.0/linux-$(TOOLCHAIN_KERNEL-HEADERS_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/include/linux/fs.h")}

${DownloadRule("$(TOOLCHAIN_KERNEL-HEADERS_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(TOOLCHAIN_KERNEL-HEADERS_FILE)", "$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)/Makefile")}

${Rule('$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)/include/generated/uapi/linux/version.h', "$(TOOLCHAIN_KERNEL-HEADERS_UNPACK)", rule_var_name=var_name("build"))} 
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR) ARCH=$(KERNEL_ARCH) headers_check

${MakeRule('CFLAGS="" CXXFLAGS=""', 'ARCH=$(KERNEL_ARCH) INSTALL_HDR_PATH=$(TOOLCHAIN_ROOT_DIR)/headers/usr', "$(TOOLCHAIN_KERNEL-HEADERS_BUILD_DIR)", "headers_install", "$(TOOLCHAIN_ROOT_DIR)/headers/usr/include/linux/fs.h", "$(TOOLCHAIN_KERNEL-HEADERS_BUILD)", var_name("local-install"))}

${Rule('$(ROOTFS_DIR)/usr/include/linux/fs.h', "$(TOOLCHAIN_KERNEL-HEADERS_LOCAL-INSTALL)", rule_var_name = var_name("install"))}
	$(CP) -R $(TOOLCHAIN_ROOT_DIR)/headers/usr $(ROOTFS_DIR)/
	
.NOTPARALLEL: