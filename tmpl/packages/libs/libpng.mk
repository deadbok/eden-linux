#mtl
${local_namespace("packages.libs.libpng")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-static
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/libpng-$(PACKAGES_LIBS_LIBPNG_VERSION)', '', '1.6.8', "http://downloads.sourceforge.net/libpng/libpng-$(PACKAGES_LIBS_LIBPNG_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/lib/libpng.a", "$(PACKAGES_ENV)")}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_LIBPNG_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: