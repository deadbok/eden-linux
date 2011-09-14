#mtl
${local_namespace("toolchain.uclibc")}

${package("$(TOOLCHAIN_BUILD_DIR)/uClibc-$(TOOLCHAIN_UCLIBC_VERSION)", "", "0.9.32", "uClibc-$(TOOLCHAIN_UCLIBC_VERSION).tar.bz2", "http://sources.buildroot.net/uClibc-$(TOOLCHAIN_UCLIBC_VERSION).tar.bz2")}

${download}

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_UCLIBC_SRC_DIR)/Makefile")}

${patchall("$(TOOLCHAIN_UCLIBC_SRC_DIR)/Makefile")}

include target/target.mk

$(TOOLCHAIN_UCLIBC_SRC_DIR)/.config: $(TARGET_UCLIBC_CONFIG)
	$(CP) -a $(TARGET_UCLIBC_CONFIG) $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config
	
include toolchain/gcc-static.mk
include toolchain/kernel-headers.mk

${local}BUILD := $(TOOLCHAIN_UCLIBC_BUILD_DIR)/lib/libc.a 
$(${local}BUILD): $(TOOLCHAIN_UCLIBC_PATCHALL) $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config $(TOOLCHAIN_KERNEL-HEADERS_INSTALL) $(TOOLCHAIN_GCC-STATIC_INSTALL)
	CFLAGS="" CXXFLAGS="" PATH=$(TOOLCHAIN_PATH) $(MAKE) -C $(TOOLCHAIN_UCLIBC_SRC_DIR) oldconfig
	CFLAGS="" CXXFLAGS="" PATH=$(TOOLCHAIN_PATH) $(MAKE) -C $(TOOLCHAIN_UCLIBC_SRC_DIR) CROSS=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" KERNEL_HEADERS=$(ROOTFS_DIR)/usr/include RUNTIME_PREFIX="$(ROOTFS_DIR)/"

${make('CFLAGS="" CXXFLAGS="" PATH=$(TOOLCHAIN_PATH)', "PREFIX=$(ROOTFS_DIR)", "install", "$(TOOLCHAIN_ROOT_DIR)/usr/include/stdio.h", "$(TOOLCHAIN_UCLIBC_BUILD)")}
