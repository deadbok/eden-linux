#mtl
${local_namespace("packages.libs.pcre")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-static
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py pcre = AutoconfPackage('$(PACKAGES_BUILD_DIR)/pcre-$(PACKAGES_LIBS_PCRE_VERSION)', '', '8.34', "http://downloads.sourceforge.net/pcre/pcre-$(PACKAGES_LIBS_PCRE_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/lib/libpcre.a", "$(PACKAGES_ENV)")}

${pcre.vars()}

${pcre.rules['download']}

#Auttoreconf needs to be run before configure
${pcre.rules['unpack']}
	($(CD) $(PACKAGES_LIBS_PCRE_BUILD_DIR); autoreconf);

${pcre.rules['patchall']}

${pcre.rules['config']}

${pcre.rules['build']}

${pcre.rules['install']}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_PCRE_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: