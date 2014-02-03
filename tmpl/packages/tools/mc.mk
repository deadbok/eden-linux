#mtl
#MC is really hard to spank into behavin nicely
${local_namespace("packages.tools.mc")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) \
						 --host=$(ARCH_TARGET)  --disable-static \
						 --with-screen=ncurses --without-x \
						 --enable-relocatable --with-sysroot=$(ROOTFS_DIR)

${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) LDFLAGS="-L$(ROOTFS_DIR)/usr/lib" 

${local()}DEPENDENCIES = $(PACKAGES_LIBS_GLIB_INSTALL) $(PACKAGES_DEV_SLANG_INSTALL)

${py mc = AutoconfPackage('$(PACKAGES_BUILD_DIR)/mc-$(PACKAGES_TOOLS_MC_VERSION)', '', '4.8.11', "http://ftp.midnight-commander.org/mc-$(PACKAGES_TOOLS_MC_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/bin/mc")}

${mc.vars()}

${mc.rules['download']}

#Auttreconf needs to be run before configure
${mc.rules['unpack']}
	($(CD) $(PACKAGES_TOOLS_MC_BUILD_DIR); $(AUTORECONF));

${mc.rules['patchall']}

#We modify glib to work around libtool trying to link to the host libintl
${mc.rules['config']}
	#(sed -i~ -e "s;/usr;$(ROOTFS_DIR)/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

${mc.rules['build']}

#Unhack glib
${mc.rules['install']}
	#(sed -i~ -e "s;$(ROOTFS_DIR)/usr;/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_TOOLS_MC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: