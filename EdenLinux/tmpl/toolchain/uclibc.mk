#mtl
${local_namespace("toolchain.uclibc")}

${package("$(TOOLCHAIN_BUILD_DIR)/uClibc-$(TOOLCHAIN_UCLIBC_VERSION)", "", "0.9.32", "uClibc-$(TOOLCHAIN_UCLIBC_VERSION).tar.bz2", "http://sources.buildroot.net/uClibc-$(TOOLCHAIN_UCLIBC_VERSION).tar.bz2")}

${download}

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_UCLIBC_SRC_DIR)/Makefile")}

${patchall("$(TOOLCHAIN_UCLIBC_UNPACK)")}

include target/target.mk

TOOLCHAIN_UCLIBC_CONFIG = $(TOOLCHAIN_UCLIBC_SRC_DIR)/.config
$(TOOLCHAIN_UCLIBC_CONFIG): $(TARGET_UCLIBC_CONFIG) $(TOOLCHAIN_UCLIBC_UNPACK)
	$(CP) -a $(TARGET_UCLIBC_CONFIG) $(TOOLCHAIN_UCLIBC_CONFIG)
	
include toolchain/gcc-static.mk
include toolchain/kernel-headers.mk

${make('CFLAGS="" CXXFLAGS="" PATH=$(TOOLCHAIN_PATH)', "", "oldconfig", "$(TOOLCHAIN_UCLIBC_SRC_DIR)/include/config/auto.conf", "$(TOOLCHAIN_UCLIBC_CONFIG) $(TOOLCHAIN_UCLIBC_PATCHALL)")}

${make('CFLAGS="" CXXFLAGS="" PATH=$(TOOLCHAIN_PATH)', 'CROSS=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" KERNEL_HEADERS=$(ROOTFS_DIR)/usr/include RUNTIME_PREFIX="$(ROOTFS_DIR)/"', "all", "$(TOOLCHAIN_UCLIBC_BUILD_DIR)/lib/libc.so", "$(TOOLCHAIN_UCLIBC_OLDCONFIG) $(TOOLCHAIN_KERNEL-HEADERS_INSTALL) $(TOOLCHAIN_GCC-STATIC_INSTALL)")}

${make('CFLAGS="" CXXFLAGS="" PATH=$(TOOLCHAIN_PATH)', "PREFIX=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/lib/libc.so.0", "$(TOOLCHAIN_UCLIBC_ALL)")}
