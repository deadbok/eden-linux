#mtl
${local_namespace("toolchain.gmp")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(TOOLCHAIN_LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) 
#ABI=$(ABI)
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(TOOLCHAIN_LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(TOOLCHAIN_LDFLAGS)

${AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/gmp-$(TOOLCHAIN_GMP_VERSION)', '', '5.1.3', "ftp://ftp.gnu.org/pub/pub/gnu/gmp/gmp-$(TOOLCHAIN_GMP_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/lib/libgmp.la")}


.NOTPARALLEL: