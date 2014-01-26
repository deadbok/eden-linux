#mtl
${local_namespace("toolchain.mpc")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR)
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${py mpc = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/mpc-$(TOOLCHAIN_MPC_VERSION)', '', '0.9', "http://www.multiprecision.org/mpc/download/mpc-$(TOOLCHAIN_MPC_VERSION).tar.gz", "$(TOOLCHAIN_ROOT_DIR)/lib/libmpc.la")}
${py mpc.rules['config'].dependencies += ' $(TOOLCHAIN_MPFR_INSTALL)'} 
include toolchain/mpfr.mk
      
${mpc}

#${package("$(TOOLCHAIN_BUILD_DIR)/mpc-$(TOOLCHAIN_MPC_VERSION)", "", "0.9", "mpc-$(TOOLCHAIN_MPC_VERSION).tar.gz", "http://www.multiprecision.org/mpc/download/$(TOOLCHAIN_MPC_FILE)")}
#
#${download()}
#
#${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_MPC_SRC_DIR)/configure")}
#
#${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR)', "$(TOOLCHAIN_MPFR_INSTALL)")} 
#
#${make('CFLAGS="" CXXFLAGS="" ', "", "all", "$(TOOLCHAIN_MPC_BUILD_DIR)/src/libmpc.la", "$(TOOLCHAIN_MPC_CONFIG)")}
#	
#${make('CFLAGS="" CXXFLAGS="" ', "", "install", "$(TOOLCHAIN_ROOT_DIR)/lib/libmpc.la", "$(TOOLCHAIN_MPC_ALL)")}

.NOTPARALLEL: