#mtl
${local_namespace("packages.e2fsprogs")}

${package("$(PACKAGES_BUILD_DIR)/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION)", "$(PACKAGES_BUILD_DIR)/e2fsprogs-build", "1.41.6", "e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION).tar.gz", "http://dfn.dl.sourceforge.net/sourceforge/e2fsprogs/$(PACKAGES_E2FSPROGS_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_E2FSPROGS_SRC_DIR)/configure")}

${autoconf('$(TOOLCHAIN_ENV)', '--prefix=/usr --with-root-prefix="" --host=$(ARCH_TARGET) --with-cc="$(TOOLCHAIN_CC)" --with-linker=$(TOOLCHAIN_LD) --disable-tls', "")}
	
${make("$(TOOLCHAIN_ENV)", '', "all", "$(PACKAGES_E2FSPROGS_BUILD_DIR)/misc/mke2fs", "$(PACKAGES_E2FSPROGS_CONFIG)")}

${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/sbin/mke2fs", "$(PACKAGES_E2FSPROGS_ALL)")}

${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install-libs", "$(ROOTFS_DIR)/usr/lib/libext2fs.a", "$(PACKAGES_E2FSPROGS_ALL)")}
	

