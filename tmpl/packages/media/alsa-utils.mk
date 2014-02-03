#mtl
${local_namespace("packages.media.alsa-utils")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV) 

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-largefile --disable-alsaconf --with-curses=ncurses
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_LIBS_ALSA-LIB_INSTALL)

SERVICES += alsasound

${py alsautils = AutoconfPackage('$(PACKAGES_BUILD_DIR)/alsa-utils-$(PACKAGES_MEDIA_ALSA-UTILS_VERSION)', '', '1.0.27.2', "ftp://ftp.alsa-project.org/pub/utils/alsa-utils-$(PACKAGES_MEDIA_ALSA-UTILS_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/amixer", "$(PACKAGES_ENV)")}

${alsautils.vars()}

${alsautils.rules['download']}

#Autoreconf needs to be run before configure
#Rule needs README to check against
${alsautils.rules['unpack']}
	($(CD) $(PACKAGES_MEDIA_ALSA-UTILS_BUILD_DIR); $(AUTORECONF));
	$(TOUCH) $(PACKAGES_MEDIA_ALSA-UTILS_BUILD_DIR)/README
	

${alsautils.rules['patchall']}

${alsautils.rules['config']}

${alsautils.rules['build']}

#Copy the init script
${alsautils.rules['install']}
	$(CP) -R $(ROOT)/${namespace.current.replace(".", "/")}/etc $(ROOTFS_DIR)/

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_MEDIA_ALSA-UTILS_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: