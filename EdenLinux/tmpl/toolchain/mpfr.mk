#mtl
${local_namespace("toolchain.mpfr")}

include toolchain/gmp.mk

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) --enable-shared --with-gmp=$(TOOLCHAIN_ROOT_DIR)
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${py mpfr = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/mpfr-$(TOOLCHAIN_MPFR_VERSION)', '', '3.0.1', "http://www.mpfr.org/mpfr-$(TOOLCHAIN_MPFR_VERSION)/mpfr-$(TOOLCHAIN_MPFR_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/lib/libmpfr.la")}
${py mpfr.rules['config'].dependencies += ' $(TOOLCHAIN_GMP_INSTALL)'}
${mpfr}

#${package("$(TOOLCHAIN_BUILD_DIR)/mpfr-$(TOOLCHAIN_MPFR_VERSION)", "", "3.0.1", "mpfr-$(TOOLCHAIN_MPFR_VERSION).tar.bz2", "http://www.mpfr.org/mpfr-$(TOOLCHAIN_MPFR_VERSION)/$(TOOLCHAIN_MPFR_FILE)")}
#
#${download()}
#
#${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_MPFR_SRC_DIR)/configure")}
#
#${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --enable-shared --with-gmp=$(TOOLCHAIN_ROOT_DIR)', "$(TOOLCHAIN_GMP_INSTALL)")} 
#
#${make('CFLAGS="" CXXFLAGS="" ', "", "all", "$(TOOLCHAIN_MPFR_BUILD_DIR)/libmpfr.la", "$(TOOLCHAIN_MPFR_CONFIG)")}
#	
#${make('CFLAGS="" CXXFLAGS="" ', "", "install", "$(TOOLCHAIN_ROOT_DIR)/lib/libmpfr.la", "$(TOOLCHAIN_MPFR_ALL)")}

.NOTPARALLEL: