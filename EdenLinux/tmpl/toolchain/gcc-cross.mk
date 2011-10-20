#mtl
#Note: The gccgo compiler takes advantage om some features, in the gold linker,
#but I don't now how to prevent using gold, for all linking, and therefore, gccgo
#uses the old ld like the rest of the system

${local_namespace("toolchain.gcc-cross")}

${py gcc_cross = Package("$(TOOLCHAIN_BUILD_DIR)/gcc-$(TOOLCHAIN_GCC-CROSS_VERSION)", "$(TOOLCHAIN_BUILD_DIR)/gcc-cross", "4.6.1", "ftp://gcc.gnu.org/pub/gcc/releases/gcc-$(TOOLCHAIN_GCC-CROSS_VERSION)/gcc-$(TOOLCHAIN_GCC-CROSS_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-c++")}
${gcc_cross}

include toolchain/uclibc.mk

#${py autoconf = Rule("$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/Makefile", "$(TOOLCHAIN_GCC-CROSS_SRC_DIR)/configure $(TOOLCHAIN_UCLIBC_INSTALL)", None, "TOOLCHAIN_GCC-CROSS_CONFIG")}
#${py autoconf.recipe.append(Autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --host=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --build=$(HOST) --enable-c99 --enable-long-long --with-mpc=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c,c++,go --includedir=$(ROTFS_DIR)/usr/include --with-ld=$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-ld.gold', "$(TOOLCHAIN_GCC-CROSS_SRC_DIR)", "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)"))}
${py autoconf =  AutoconfRule('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --host=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --build=$(HOST) --enable-c99 --enable-long-long --with-mpc=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c,c++,go --includedir=$(ROTFS_DIR)/usr/include', "$(TOOLCHAIN_GCC-CROSS_SRC_DIR)", "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)", "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/Makefile", "$(TOOLCHAIN_GCC-CROSS_SRC_DIR)/configure $(TOOLCHAIN_UCLIBC_INSTALL)")}
${autoconf}

#${py build = Rule("$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/.build", "$(TOOLCHAIN_GCC-CROSS_CONFIG)", None, "TOOLCHAIN_GCC-CROSS_BUILD")}
#${py build.recipe.append(Make('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '', "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)", "all"))}
${py build = MakeRule('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '', "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)", "all", "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/.build", "$(TOOLCHAIN_GCC-CROSS_CONFIG)", "TOOLCHAIN_GCC-CROSS_BUILD")}
${py build.recipe.append("$(TOUCH) $(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/.build\n")}
${build}

${py install = MakeRule('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '', "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)", "install", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-c++", "$(TOOLCHAIN_GCC-CROSS_BUILD)", "TOOLCHAIN_GCC-CROSS_INSTALL")}
${py install.recipe.append("$(CP) -R $(TOOLCHAIN_ROOT_DIR)/$(ARCH_TARGET)/lib/* $(ROOTFS_DIR)/lib/\n")}
${install}
        
#
##${download}
#
##${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_GCC-CROSS_SRC_DIR)/configure")}
#
#include toolchain/uclibc.mk
#
#${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --host=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --build=$(HOST) --enable-c99 --enable-long-long --with-mpc=$(TOOLCHAIN_ROOT_DIR) --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c,c++,go --includedir=$(ROTFS_DIR)/usr/include --with-ld=$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-ld.gold''', "$(TOOLCHAIN_UCLIBC_INSTALL)")} 
#
#${make('CFLAGS="" CXXFLAGS=""', "", "all", "$(TOOLCHAIN_GCC-CROSS_BUILD_DIR)/gcc/libgcc.a", "$(TOOLCHAIN_GCC-CROSS_CONFIG)")}
#	
#${make('CFLAGS="" CXXFLAGS=""', "", "install", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-c++", "$(TOOLCHAIN_GCC-CROSS_ALL)")}
#	$(CP) -R $(TOOLCHAIN_ROOT_DIR)/$(ARCH_TARGET)/lib/* $(ROOTFS_DIR)/lib/

.NOTPARALLEL: