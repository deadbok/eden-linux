#mtl
${local_namespace("toolchain.binutils")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) --build=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --enable-gold
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${py binutils = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/binutils-$(TOOLCHAIN_BINUTILS_VERSION)', '$(TOOLCHAIN_BUILD_DIR)/binutils-build', '2.21.1', "ftp://gcc.gnu.org/pub/binutils/releases/binutils-$(TOOLCHAIN_BINUTILS_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-readelf")}

${py binutils.rules['build'].dependencies += ' $(TOOLCHAIN_BINUTILS_CONFIGURE-HOST)'}

${binutils.vars()}

${binutils.rules['download']}

${binutils.rules['unpack']}

${binutils.rules['config']}

${local()}CONFIGURE-HOST = $(TOOLCHAIN_BINUTILS_BUILD_DIR)/ld/Makefile
$(TOOLCHAIN_BINUTILS_CONFIGURE-HOST): $(TOOLCHAIN_BINUTILS_CONFIG)
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_BINUTILS_BUILD_DIR) configure-host

${binutils.rules['build']}

${binutils.rules['install']}

#${package("$(TOOLCHAIN_BUILD_DIR)/binutils-$(TOOLCHAIN_BINUTILS_VERSION)", "$(TOOLCHAIN_BUILD_DIR)/binutils-build", "2.21.1", "binutils-$(TOOLCHAIN_BINUTILS_VERSION).tar.bz2", "ftp://gcc.gnu.org/pub/binutils/releases/$(TOOLCHAIN_BINUTILS_FILE)")}
#
#${download()}
#
#${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_BINUTILS_SRC_DIR)/configure")}
#
#$(TOOLCHAIN_BINUTILS_BUILD_DIR):
#	$(MKDIR) $(TOOLCHAIN_BINUTILS_BUILD_DIR)
#
#${autoconf('CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)', '--prefix=$(TOOLCHAIN_ROOT_DIR) --build=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --enable-gold', "$(TOOLCHAIN_BINUTILS_BUILD_DIR)")} 	
#
#${make('CFLAGS="" CXXFLAGS=""', "", "configure-host", "$(TOOLCHAIN_BINUTILS_BUILD_DIR)/ld/Makefile", "$(TOOLCHAIN_BINUTILS_CONFIG)")}
#
#${make('CFLAGS="" CXXFLAGS=""', "", "all", "$(TOOLCHAIN_BINUTILS_BUILD_DIR)/binutils/objcopy", "$(TOOLCHAIN_BINUTILS_CONFIGURE-HOST)")}
#	
#${make('CFLAGS="" CXXFLAGS=""', "", "install", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-readelf", "$(TOOLCHAIN_BINUTILS_ALL)")}

.NOTPARALLEL: