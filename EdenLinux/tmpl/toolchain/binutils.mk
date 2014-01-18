#mtl
${local_namespace("toolchain.binutils")}

#Package specific values for autoconf
${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}CONFIG_PARAM = --prefix=$(TOOLCHAIN_ROOT_DIR) --build=$(HOST) --target=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-nls --enable-shared --disable-multilib --enable-plugins
${local()}CONFIG_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = CFLAGS="" CXXFLAGS="" LDFLAGS=$(LDFLAGS)

#Generate a set of rules for building this package
${py binutils = AutoconfPackage('$(TOOLCHAIN_BUILD_DIR)/binutils-$(TOOLCHAIN_BINUTILS_VERSION)', '$(TOOLCHAIN_BUILD_DIR)/binutils-build', '2.23.2', "ftp://gcc.gnu.org/pub/binutils/releases/binutils-$(TOOLCHAIN_BINUTILS_VERSION).tar.bz2", "$(TOOLCHAIN_ROOT_DIR)/bin/$(ARCH_TARGET)-readelf")}

#Add a patch rule as a dependency of the config rule
${py binutils.rules['config'].dependencies += ' $(TOOLCHAIN_BINUTILS_PATCHALL)'}

#Add a host configure rule specially needed by binutils
${py binutils.rules['build'].dependencies += ' $(TOOLCHAIN_BINUTILS_CONFIGURE-HOST)'}

#Output generated variables for bintutils comiplation
${binutils.vars()}

#Output the download rule
${binutils.rules['download']}

#Output the unpack rule
${binutils.rules['unpack']}

#Create a rule to patch binutils
${PatchRule("$(TOOLCHAIN_BINUTILS_UNPACK)")}

#Output config rule
${binutils.rules['config']}

  
${MakeRule('CFLAGS="" CXXFLAGS=""', '', var_name('build_dir', True), 'configure-host', '$(TOOLCHAIN_BINUTILS_BUILD_DIR)/ld/Makefile', var_name('config', True), var_name('configure-host'))}

${binutils.rules['build']}

${binutils.rules['install']}

.NOTPARALLEL: