#mtl
${local_namespace("packages.dev.libtool")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR)
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/libtool-$(PACKAGES_DEV_LIBTOOL_VERSION)', '', '2.4', "ftp://ftp.gnu.org/gnu/libtool/libtool-$(PACKAGES_DEV_LIBTOOL_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/lib/libltdl.a", "$(PACKAGES_ENV)")}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_DEV_LIBTOOL_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: