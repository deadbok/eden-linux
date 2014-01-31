#mtl
${local_namespace("packages.libs.glib")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV) 

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) 
${local()}CONFIG_ENV = $(PACKAGES_ENV) glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=no

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) glib_cv_stack_grows=no glib_cv_uscore=no ac_cv_func_posix_getpwuid_r=yes ac_cv_func_posix_getgrgid_r=no

${local()}DEPENDENCIES = $(PACKAGES_LIBS_LIBFFI_INSTALL) $(PACKAGES_TOOLS_GETTEXT_INSTALL)

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/glib-$(PACKAGES_LIBS_GLIB_VERSION)', '', '2.38.2', "ftp://ftp.gnome.org/pub/gnome/sources/glib/2.38/glib-$(PACKAGES_LIBS_GLIB_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/lib/libglib-2.0.a", "$(PACKAGES_ENV)")}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_LIBS_GLIB_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: