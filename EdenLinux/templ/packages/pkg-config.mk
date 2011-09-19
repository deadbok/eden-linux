#mtl
${local_namespace("packages.pkg-config")}

${package("$(PACKAGES_BUILD_DIR)/pkg-config-$(PACKAGES_PKG-CONFIG_VERSION)", "", "0.26", "pkg-config-$(PACKAGES_PKG-CONFIG_VERSION).tar.gz", "http://pkgconfig.freedesktop.org/releases/$(PACKAGES_PKG-CONFIG_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_PKG-CONFIG_SRC_DIR)/configure")}

${autoconf('$(TOOLCHAIN_ENV)', '--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --enable-tiny --program-prefix=', "")}

${make("$(TOOLCHAIN_ENV)", '', "all", "$(PACKAGES_PKG-CONFIG_BUILD_DIR)/src/pkg-config", "$(PACKAGES_PKG-CONFIG_CONFIG)")}

${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/usr/bin/pkg-config", "$(PACKAGES_PKG-CONFIG_ALL)")}
