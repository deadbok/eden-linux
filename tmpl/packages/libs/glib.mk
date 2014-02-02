#mtl
${local_namespace("packages.libs.glib")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV) 

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR)
${local()}CONFIG_ENV = $(PACKAGES_ENV) glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=no

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=no

${local()}DEPENDENCIES = $(PACKAGES_LIBS_LIBFFI_INSTALL) $(PACKAGES_TOOLS_GETTEXT_INSTALL)

${py glib = AutoconfPackage('$(PACKAGES_BUILD_DIR)/glib-$(PACKAGES_LIBS_GLIB_VERSION)', '', '2.38.2', "ftp://ftp.gnome.org/pub/gnome/sources/glib/2.38/glib-$(PACKAGES_LIBS_GLIB_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/lib/libglib-2.0.so", "$(PACKAGES_ENV)")}

${glib.vars()}

${glib.rules['download']}

#Auttreconf needs to be run before configure
${glib.rules['unpack']}
	($(CD) $(PACKAGES_LIBS_GLIB_BUILD_DIR); autoreconf);

${glib.rules['patchall']}

#We modify glib to work around libtool trying to link to the host libintl
${glib.rules['config']}
#	(sed -i~ -e "s;/usr;$(ROOTFS_DIR)/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

${glib.rules['build']}

#Unhack glib
${glib.rules['install']}
#	(sed -i~ -e "s;$(ROOTFS_DIR)/usr;/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_GLIB_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: