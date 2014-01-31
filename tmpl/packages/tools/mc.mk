#mtl
#MC is really hard to spank into behavin nicely
${local_namespace("packages.tools.mc")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) \
						 --host=$(ARCH_TARGET)  --disable-static \
						 --with-screen=ncurses --without-x \
						 --enable-relocatable

${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) LDFLAGS="-L$(ROOTFS_DIR)/usr/lib" 

${local()}DEPENDENCIES = $(PACKAGES_LIBS_GLIB_INSTALL) $(PACKAGES_DEV_SLANG_INSTALL)

#fu_cv_sys_stat_statfs2_bsize=yes samba_cv_HAVE_GETTIMEOFDAY_TZ=yes ac_cv_search_has_colors="-lncursesw" GLIB_CFLAGS="-I$GLIB -I$GLIB/glib" GLIB_LIBDIR="$GLIB/glib/.libs" GLIB_LIBS="-L$GLIB/glib/.libs" GMODULE_CFLAGS="-I$GLIB" GMODULE_LIBS="-L$GLIB/gmodule/.libs" CFLAGS="$CFLAGS -O3 $GLIB_CFLAGS $GMODULE_CFLAGS" LDFLAGS="$GLIB_LIBS $GMODULE_LIBS" LIBS="-lglib-2.0 -lgmodule-2.0" ./configure --host=arm-none-linux-gnueabi --prefix=$DEST --with-screen=ncurses --with-ncurses-includes="$NCURSES/include" --with-ncurses-libs="$NCURSES/lib" --without-gpm-mouse --with-glib-static --enable-vfs-smb --without-x --with-smb-configdir=$DEST/etc --with-smb-codepagedir=$DEST/etc/codepages
#make clean && make && make install

${py mc = AutoconfPackage('$(PACKAGES_BUILD_DIR)/mc-$(PACKAGES_TOOLS_MC_VERSION)', '', '4.8.11', "http://ftp.midnight-commander.org/mc-$(PACKAGES_TOOLS_MC_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/bin/mc")}

${mc.vars()}

${mc.rules['download']}

#Auttreconf needs to be run before configure
${mc.rules['unpack']}
	($(CD) $(PACKAGES_TOOLS_MC_BUILD_DIR); autoreconf);

${mc.rules['patchall']}

#We modify glib to work around libtool trying to link to the host libintl
${mc.rules['config']}
	(sed -i~ -e "s;/usr;$(ROOTFS_DIR)/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

${mc.rules['build']}

#Unhack glib
${mc.rules['install']}
	(sed -i~ -e "s;$(ROOTFS_DIR)/usr;/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_TOOLS_MC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: