#mtl
${local_namespace("packages.tools.gettext")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV) 

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET)  --disable-static --disable-libasprintf --disable-acl --disable-openmp --disable-rpath --disable-java --disable-native-java --disable-csharp --without-emacs --with-included-gettext
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/gettext-$(PACKAGES_TOOLS_GETTEXT_VERSION)', '', '0.18.3.1', "http://ftp.gnu.org/pub/gnu/gettext/gettext-$(PACKAGES_TOOLS_GETTEXT_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/gettext", "$(PACKAGES_ENV)")}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_TOOLS_GETTEXT_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: