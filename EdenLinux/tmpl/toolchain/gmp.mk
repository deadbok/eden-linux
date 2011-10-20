#mtl
${local_namespace("toolchain.gmp")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR)
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${py gmp = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/gmp-$(TOOLCHAIN_GMP_VERSION)', '', '5.0.1', "ftp://ftp.gnu.org/pub/pub/gnu/gmp/gmp-$(TOOLCHAIN_GMP_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/lib/libgmp.la")}
${gmp}

.NOTPARALLEL: