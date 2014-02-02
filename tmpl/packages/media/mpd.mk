#mtl
${local_namespace("packages.media.mpd")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET)
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_LIBS_MPG123_INSTALL)

${py mpd = AutoconfPackage('$(PACKAGES_BUILD_DIR)/mpd-$(PACKAGES_MEDIA_MPD_VERSION)', '', '0.18.7', "http://www.musicpd.org/download/mpd/stable/mpd-$(PACKAGES_MEDIA_MPD_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/bin/mpd", "$(PACKAGES_ENV)")}

${mpd.vars()}

${mpd.rules['download']}

#Auttreconf needs to be run before configure
${mpd.rules['unpack']}
	($(CD) $(PACKAGES_MEDIA_MPD_BUILD_DIR); autoreconf);

${mpd.rules['patchall']}

#We modify glib to work around libtool trying to link to the host libintl
${mpd.rules['config']}

${mpd.rules['build']}

#Unhack glib
${mpd.rules['install']}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_MEDIA_MPD_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: