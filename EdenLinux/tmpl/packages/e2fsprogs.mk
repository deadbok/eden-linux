#mtl
${local_namespace("packages.e2fsprogs")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --with-root-prefix="" --host=$(ARCH_TARGET) --disable-tls
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION)', '$(PACKAGES_BUILD_DIR)/e2fsprogs-build', '1.41.6', "http://dfn.dl.sourceforge.net/sourceforge/e2fsprogs/e2fsprogs-$(PACKAGES_E2FSPROGS_VERSION).tar.gz", "$(ROOTFS_DIR)/sbin/mke2fs")}
	
#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_E2FSPROGS_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_E2FSPROGS_INSTALL)
PACKAGES_NAME_TARGETS += e2fsprogs
.NOTPARALLEL: