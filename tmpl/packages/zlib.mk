#mtl
${local_namespace("packages.zlib")}

${local()}INSTALL_PARAM = prefix=$(ROOTFS_DIR)/usr -j1
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --shared
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = -j1
${local()}BUILD_ENV = $(PACKAGES_ENV)  

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/zlib-$(PACKAGES_ZLIB_VERSION)', '', '1.2.8', "http://www.zlib.net/zlib-$(PACKAGES_ZLIB_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/libz.a")}

##Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_ZLIB_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: