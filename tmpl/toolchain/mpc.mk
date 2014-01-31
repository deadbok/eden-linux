#mtl
${local_namespace("toolchain.mpc")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(TOOLCHAIN_LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR)
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(TOOLCHAIN_LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(TOOLCHAIN_LDFLAGS)

${py mpc = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/mpc-$(TOOLCHAIN_MPC_VERSION)', '', '0.9', "http://www.multiprecision.org/mpc/download/mpc-$(TOOLCHAIN_MPC_VERSION).tar.gz", "$(TOOLCHAIN_ROOT_DIR)/lib/libmpc.la")}
${py mpc.rules['config'].dependencies += ' $(TOOLCHAIN_MPFR_INSTALL)'} 
include toolchain/mpfr.mk
      
.NOTPARALLEL: