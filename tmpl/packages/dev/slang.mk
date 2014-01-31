#mtl
${local_namespace("packages.dev.slang")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR) -j1
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET)
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = -j1
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${local()}DEPENDENCIES = $(PACKAGES_LIBS_PCRE_INSTALL) $(PACKAGES_LIBS_LIBPNG_INSTALL)

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/slang-$(PACKAGES_DEV_SLANG_VERSION)', '', '2.2.4', "ftp://ftp.fu-berlin.de/pub/unix/misc/slang/v2.2/slang-$(PACKAGES_DEV_SLANG_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/libslang.so")}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_DEV_SLANG_INSTALL) 
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: