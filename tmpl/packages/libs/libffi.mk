#mtl
${local_namespace("packages.libs.libffi")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-static --disable-builddir
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/libffi-$(PACKAGES_LIBS_LIBFFI_VERSION)', '', '3.0.13', "ftp://sourceware.org/pub/libffi/libffi-$(PACKAGES_LIBS_LIBFFI_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/libffi.so", "$(PACKAGES_ENV)")}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_LIBFFI_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: