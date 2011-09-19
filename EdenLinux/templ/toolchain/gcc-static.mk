#mtl
${local_namespace("toolchain.gcc-static")}

${package("$(TOOLCHAIN_BUILD_DIR)/gcc-$(TOOLCHAIN_GCC-STATIC_VERSION)", "$(TOOLCHAIN_BUILD_DIR)/gcc-static", "4.6.1", "gcc-$(TOOLCHAIN_GCC-CROSS_VERSION).tar.bz2", "ftp://gcc.gnu.org/pub/gcc/releases/gcc-$(TOOLCHAIN_GCC-STATIC_VERSION)/$(TOOLCHAIN_GCC-STATIC_FILE)")}

${download}

$(TOOLCHAIN_GCC-STATIC_BUILD_DIR):
	$(MKDIR) $(TOOLCHAIN_GCC-STATIC_BUILD_DIR)

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_GCC-STATIC_SRC_DIR)/configure")}

include toolchain/binutils.mk
include toolchain/mpc.mk

TOOLCHAIN_GCC-STATIC_CONFIG := $(TOOLCHAIN_GCC-STATIC_BUILD_DIR)/Makefile
$(TOOLCHAIN_GCC-STATIC_CONFIG): $(TOOLCHAIN_GCC-STATIC_BUILD_DIR) $(TOOLCHAIN_GCC-STATIC_SRC_DIR)/configure $(TOOLCHAIN_BINUTILS_INSTALL) $(TOOLCHAIN_MPC_INSTALL)
	(cd $(TOOLCHAIN_GCC-STATIC_BUILD_DIR); \
		CFLAGS="" CXXFLAGS="" AR=ar LDFLAGS=$(LDFLAGS) $(TOOLCHAIN_GCC-STATIC_SRC_DIR)/configure --prefix=$(TOOLCHAIN_ROOT_DIR) --with-newlib --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --disable-shared --disable-multilib --disable-libmudflap --disable-libssp --without-headers --with-mpc=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c --build=$(HOST) --host=$(HOST) --disable-decimal-float --disable-libgomp --disable-threads --without-ppl --without-cloog --disable-libquadmath\
	);
	
TOOLCHAIN_GCC-STATIC_ALL :=  $(TOOLCHAIN_GCC-STATIC_BUILD_DIR)/gcc/libgcc.a
$(TOOLCHAIN_GCC-STATIC_ALL): $(TOOLCHAIN_GCC-STATIC_CONFIG)
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_GCC-STATIC_BUILD_DIR) all-gcc all-target-libgcc
	
${make('CFLAGS="" CXXFLAGS=""', "", "install", "$(TOOLCHAIN_ROOT_DIR)/.gcc-static", "$(TOOLCHAIN_GCC-STATIC_ALL)")}
	$(TOUCH) $(TOOLCHAIN_GCC-STATIC_INSTALL)
