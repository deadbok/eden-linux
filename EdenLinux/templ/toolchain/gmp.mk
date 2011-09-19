#mtl
${local_namespace("toolchain.gmp")}

${package("$(TOOLCHAIN_BUILD_DIR)/gmp-$(TOOLCHAIN_GMP_VERSION)", "", "5.0.1", "gmp-$(TOOLCHAIN_GMP_VERSION).tar.bz2", "ftp://ftp.gnu.org/pub/pub/gnu/gmp/$(TOOLCHAIN_GMP_FILE)")}

${download}

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_GMP_SRC_DIR)/configure")}

${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR)', "")}

${make('CFLAGS="" CXXFLAGS=""', "", "all", "$(TOOLCHAIN_GMP_BUILD_DIR)/libgmp.la", "$(TOOLCHAIN_GMP_CONFIG)")}

${make('CFLAGS="" CXXFLAGS=""', "", "install", "$(TOOLCHAIN_ROOT_DIR)/lib/libgmp.la", "$(TOOLCHAIN_GMP_ALL)")}

