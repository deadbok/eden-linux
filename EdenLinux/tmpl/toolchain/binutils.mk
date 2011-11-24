#mtl
${local_namespace("toolchain.binutils")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) --build=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --enable-gold --enable-plugins
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${py binutils = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/binutils-$(TOOLCHAIN_BINUTILS_VERSION)', '$(TOOLCHAIN_BUILD_DIR)/binutils-build', '2.21.1', "ftp://gcc.gnu.org/pub/binutils/releases/binutils-$(TOOLCHAIN_BINUTILS_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-readelf")}

${py binutils.rules['config'].dependencies += ' $(TOOLCHAIN_BINUTILS_PATCHALL)'}

${py binutils.rules['build'].dependencies += ' $(TOOLCHAIN_BINUTILS_CONFIGURE-HOST)'}

${binutils.vars()}

${binutils.rules['download']}

${binutils.rules['unpack']}

${PatchRule("$(TOOLCHAIN_BINUTILS_UNPACK)")}

${binutils.rules['config']}

${local()}CONFIGURE-HOST = $(TOOLCHAIN_BINUTILS_BUILD_DIR)/ld/Makefile
$(TOOLCHAIN_BINUTILS_CONFIGURE-HOST): $(TOOLCHAIN_BINUTILS_CONFIG)
	CFLAGS="" CXXFLAGS="" $(MAKE) -C $(TOOLCHAIN_BINUTILS_BUILD_DIR) configure-host

${binutils.rules['build']}

${binutils.rules['install']}

.NOTPARALLEL: