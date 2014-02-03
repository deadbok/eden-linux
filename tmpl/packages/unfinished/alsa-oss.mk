#mtl
${local_namespace("packages.media.alsa-oss")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV) 

#--with-curses=ncurses
${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) \
						 --host=$(ARCH_TARGET) --disable-nls
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_LIBS_ALSA-LIB_INSTALL)

${py alsaoss = AutoconfPackage('$(PACKAGES_BUILD_DIR)/alsa-oss-$(PACKAGES_MEDIA_ALSA-OSS_VERSION)', '', '1.0.25', "ftp://ftp.alsa-project.org/pub/oss-lib/alsa-oss-$(PACKAGES_MEDIA_ALSA-OSS_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/a", "$(PACKAGES_ENV)")}

${alsaoss.vars()}

${alsaoss.rules['download']}

#Autoreconf needs to be run before configure
#Rule needs README to check against
${alsaoss.rules['unpack']}
	#($(CD) $(PACKAGES_MEDIA_ALSA-OSS_BUILD_DIR); $(AUTORECONF));
	$(TOUCH) $(PACKAGES_MEDIA_ALSA-OSS_BUILD_DIR)/README
	

${alsaoss.rules['patchall']}

${alsaoss.rules['config']}

${alsaoss.rules['build']}

#Copy the init script
${alsaoss.rules['install']}
	$(CP) -R $(ROOT)/${namespace.current.replace(".", "/")}/etc $(ROOTFS_DIR)/

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_MEDIA_ALSA-OSS_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: