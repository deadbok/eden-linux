#mtl
${local_namespace("toolchain.gcc-static")}

${Package("$(TOOLCHAIN_BUILD_DIR)/gcc-$(TOOLCHAIN_GCC-STATIC_VERSION)", "$(TOOLCHAIN_BUILD_DIR)/gcc-static", "4.7.3", "ftp://gcc.gnu.org/pub/gcc/releases/gcc-$(TOOLCHAIN_GCC-STATIC_VERSION)/gcc-$(TOOLCHAIN_GCC-STATIC_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/gcc-static/bin/$(ARCH_TARGET)-c++")}

${DownloadRule("$(TOOLCHAIN_GCC-STATIC_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(TOOLCHAIN_GCC-STATIC_FILE)", "$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_GCC-STATIC_SRC_DIR)/configure")}

include toolchain/binutils.mk
include toolchain/mpc.mk

${AutoconfRule('CFLAGS="" CXXFLAGS="" AR=ar LDFLAGS=$(TOOLCHAIN_LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --bindir=$(TOOLCHAIN_ROOT_DIR)/gcc-static/bin --libdir=$(TOOLCHAIN_ROOT_DIR)/gcc-static/lib --libexecdir=$(TOOLCHAIN_ROOT_DIR)/gcc-static/libexec --with-newlib --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --disable-shared --disable-multilib --disable-libmudflap --disable-libssp --without-headers --with-mpc=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c --build=$(HOST) --host=$(HOST) --disable-decimal-float --disable-libgomp --disable-threads --without-ppl --without-cloog --disable-libquadmath $(GCC_EXTRA_CONFIG)', "$(TOOLCHAIN_GCC-STATIC_SRC_DIR)", "$(TOOLCHAIN_GCC-STATIC_BUILD_DIR)", "$(TOOLCHAIN_GCC-STATIC_BUILD_DIR)/Makefile", "$(TOOLCHAIN_ROOT_DIR)/gcc-static/.dir $(TOOLCHAIN_GCC-STATIC_SRC_DIR)/configure $(TOOLCHAIN_BINUTILS_INSTALL) $(TOOLCHAIN_MPC_INSTALL)")}	

${MakeRule('CFLAGS="" CXXFLAGS=""', '', "$(TOOLCHAIN_GCC-STATIC_BUILD_DIR)", "all-gcc all-target-libgcc", "$(TOOLCHAIN_GCC-STATIC_BUILD_DIR)/gcc/libgcc.a", "$(TOOLCHAIN_GCC-STATIC_CONFIG)", "TOOLCHAIN_GCC-STATIC_BUILD")}

$(TOOLCHAIN_ROOT_DIR)/gcc-static/.dir:
	$(MKDIR) $(TOOLCHAIN_ROOT_DIR)/gcc-static
	$(TOUCH) $(TOOLCHAIN_ROOT_DIR)/gcc-static/.dir

${MakeRule('CFLAGS="" CXXFLAGS=""', '', "$(TOOLCHAIN_GCC-STATIC_BUILD_DIR)", "install-gcc install-target-libgcc", "$(TOOLCHAIN_ROOT_DIR)/gcc-static/bin/$(ARCH_TARGET)-c++", "$(TOOLCHAIN_GCC-STATIC_BUILD)", "TOOLCHAIN_GCC-STATIC_INSTALL", True)}
	$(TOUCH) $(TOOLCHAIN_GCC-STATIC_INSTALL)

#This is a path definition, that makes sure, the static gcc, is called first.
GCC-STATIC_PATH = $(TOOLCHAIN_ROOT_DIR)/gcc-static/bin:$(TOOLCHAIN_ROOT_DIR)/bin:$(PATH)

.NOTPARALLEL: