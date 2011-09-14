#mtl
${local_namespace("toolchain.mpc")}

${package("$(TOOLCHAIN_BUILD_DIR)/mpc-$(TOOLCHAIN_MPC_VERSION)", "", "0.9", "mpc-$(TOOLCHAIN_MPC_VERSION).tar.gz", "http://www.multiprecision.org/mpc/download/$(TOOLCHAIN_MPC_FILE)")}

${download}

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_MPC_SRC_DIR)/configure")}

include toolchain/mpfr.mk

${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR)', "$(TOOLCHAIN_MPFR_INSTALL)")} 

${make('CFLAGS="" CXXFLAGS="" ', "", "all", "$(TOOLCHAIN_MPC_BUILD_DIR)/src/libmpc.la", "$(TOOLCHAIN_MPC_CONFIG)")}
	
${make('CFLAGS="" CXXFLAGS="" ', "", "install", "$(TOOLCHAIN_ROOT_DIR)/lib/libmpc.la", "$(TOOLCHAIN_MPC_ALL)")}

