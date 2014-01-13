#mtl
${local_namespace("packages.e2fsprogs")}

#${package("$(PACKAGES_BUILD_DIR)/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION)", "$(PACKAGES_BUILD_DIR)/e2fsprogs-build", "1.41.6", "e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION).tar.gz", "http://dfn.dl.sourceforge.net/sourceforge/e2fsprogs/$(PACKAGES_E2FSPROGS_FILE)")}

#${download()}

#${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_E2FSPROGS_SRC_DIR)/configure")}

#${autoconf('$(PACKAGES_ENV)', '--prefix=/usr --with-root-prefix="" --host=$(ARCH_TARGET) --with-cc="$(TOOLCHAIN_CC)" --with-linker=$(TOOLCHAIN_LD) --disable-tls', "")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --with-root-prefix="" --host=$(ARCH_TARGET) --with-cc="$(TOOLCHAIN_CC)" --with-linker=$(TOOLCHAIN_LD) --disable-tls
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

#${py e2fsprogs = AutoconfPackage('$(PACKAGES_BUILD_DIR)/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION)', '$(PACKAGES_BUILD_DIR)/e2fsprogs-build', '1.41.6', "http://dfn.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION).tar.gz", "$(ROOTFS_DIR)/sbin/mke2fs")}
#${e2fsprogs}
${AutoconfPackage('$(PACKAGES_BUILD_DIR)/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION)', '$(PACKAGES_BUILD_DIR)/e2fsprogs-build', '1.41.6', "http://dfn.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION).tar.gz", "$(ROOTFS_DIR)/sbin/mke2fs")}
	
#${make("$(PACKAGES_ENV)", '', "all", "$(PACKAGES_E2FSPROGS_BUILD_DIR)/misc/mke2fs", "$(PACKAGES_E2FSPROGS_CONFIG)")}

##${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/sbin/mke2fs", "$(PACKAGES_E2FSPROGS_ALL)")}

#${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install-libs", "$(ROOTFS_DIR)/usr/lib/libext2fs.a", "$(PACKAGES_E2FSPROGS_ALL)")}
	

.NOTPARALLEL: