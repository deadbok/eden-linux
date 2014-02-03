#mtl
${local_namespace("packages.libs.mpg123")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --build=$(HOST) --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR) --disable-static --with-modules --with-module-suffix=.so
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_DEV_LIBTOOL_INSTALL) $(PACKAGES_LIBS_ALSA-LIB_INSTALL)

${py mpg123 = AutoconfPackage('$(PACKAGES_BUILD_DIR)/mpg123-$(PACKAGES_LIBS_MPG123_VERSION)', '', '1.18.0', "http://www.mpg123.de/download/mpg123-$(PACKAGES_LIBS_MPG123_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/mpg123", "$(PACKAGES_ENV)")}

${mpg123.vars()}

${mpg123.rules['download']}

#Auttreconf needs to be run before configure
${mpg123.rules['unpack']}
	($(CD) $(PACKAGES_LIBS_MPG123_BUILD_DIR); $(AUTORECONF));
	(sed -i~ -e "s;/usr;$(ROOTFS_DIR)/usr;" $(ROOTFS_DIR)/usr/lib/libltdl.la);

${mpg123.rules['patchall']}

${mpg123.rules['config']}

${mpg123.rules['build']}

${mpg123.rules['install']}
	(sed -i~ -e "s;$(ROOTFS_DIR)/usr;/usr;" $(ROOTFS_DIR)/usr/lib/libltdl.la);

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_MPG123_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: