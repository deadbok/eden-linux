#mtl
${local_namespace("toolchain.gcc-cross")}

${package("$(TOOLCHAIN_BUILD_DIR)/gcc-$(TOOLCHAIN_GCC-CROSS_VERSION)", "$(TOOLCHAIN_BUILD_DIR)/gcc-cross", "4.6.1", "gcc-$(TOOLCHAIN_GCC-CROSS_VERSION).tar.bz2", "ftp://gcc.gnu.org/pub/gcc/releases/gcc-$(TOOLCHAIN_GCC-CROSS_VERSION)/$(TOOLCHAIN_GCC-CROSS_FILE)")}


#${download}

#${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_GCC-CROSS_SRC_DIR)/configure")}

include toolchain/uclibc.mk

${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --host=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --build=$(HOST) --enable-c99 --enable-long-long --with-mpc=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c,c++,go --includedir=$(ROTFS_DIR)/usr/include''', "$(TOOLCHAIN_UCLIBC_INSTALL)")} 

${make('CFLAGS="" CXXFLAGS=""', "", "all", "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/gcc/libgcc.a", "$(TOOLCHAIN_GCC-CROSS_CONFIG)")}
	
${make('CFLAGS="" CXXFLAGS=""', "", "install", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-c++", "$(TOOLCHAIN_GCC-CROSS_ALL)")}
	$(CP) -R $(TOOLCHAIN_ROOT_DIR)/$(ARCH_TARGET)/lib/* $(ROOTFS_DIR)/lib/
