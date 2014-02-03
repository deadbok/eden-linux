#mtl
${local_namespace("packages.libs.alsa-lib")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV) 

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-python --with-sysroot=$(ROOTFS_DIR)
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES =

${py alsalib = AutoconfPackage('$(PACKAGES_BUILD_DIR)/alsa-lib-$(PACKAGES_LIBS_ALSA-LIB_VERSION)', '', '1.0.27.2', "ftp://ftp.alsa-project.org/pub/lib/alsa-lib-$(PACKAGES_LIBS_ALSA-LIB_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/lib/libasound.so", "$(PACKAGES_ENV)")}

${alsalib.vars()}

${alsalib.rules['download']}

#Auttreconf needs to be run before configure
${alsalib.rules['unpack']}
	($(CD) $(PACKAGES_LIBS_ALSA-LIB_BUILD_DIR); $(AUTORECONF));
	$(TOUCH) $(PACKAGES_LIBS_ALSA-LIB_BUILD_DIR)/README

${alsalib.rules['patchall']}

${alsalib.rules['config']}

${alsalib.rules['build']}

${alsalib.rules['install']}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_ALSA-LIB_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: