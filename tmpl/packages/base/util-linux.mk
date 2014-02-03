#mtl
${local_namespace("packages.base.util-linux")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-libuuid --disable-losetup --disable-cytune --disable-fsck --disable-partx --disable-uuidd --disable-mountpoint --disable-fallocate --disable-unshare --disable-nsenter --disable-setpriv --disable-eject --disable-agetty --disable-cramfs --disable-bfs --disable-fdformat --disable-hwclock --disable-wdctl --disable-switch_root --disable-pivot_root --disable-kill --disable-last --disable-utmpdump --disable-utmpdump --disable-mesg --disable-raw --disable-rename --disable-login --disable-nologin --disable-sulogin --disable-su --disable-runuser --disable-ul --disable-more --disable-pg --disable-setterm --disable-schedutils --disable-wall --disable-bash-completion --with-sysroot=$(ROOTFS_DIR)
${local()}CONFIG_ENV = $(PACKAGES_ENV) scanf_cv_alloc_modifier=as

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_BASE_BUSYBOX_INSTALL) 

${py utillinux = AutoconfPackage('$(PACKAGES_BUILD_DIR)/util-linux-$(PACKAGES_BASE_UTIL-LINUX_VERSION)', '', '2.24.1', "http://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-$(PACKAGES_BASE_UTIL-LINUX_VERSION).tar.xz", "$(ROOTFS_DIR)/sbin/swapon")}

#Inset autogen call
${py utillinux.rules['config'].recipe.insert(2, '($(CD) $(PACKAGES_BASE_UTIL-LINUX_BUILD_DIR); ./autogen.sh); ')}

${utillinux.vars()}

${utillinux.rules['download']}

#Auttreconf needs to be run before configure
${utillinux.rules['unpack']}
	($(CD) $(PACKAGES_BASE_UTIL-LINUX_BUILD_DIR); $(AUTORECONF));

${utillinux.rules['patchall']}

#We modify glib to work around libtool trying to link to the host libintl
${utillinux.rules['config']}
#	(sed -i~ -e "s;/usr;$(ROOTFS_DIR)/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

${utillinux.rules['build']}

#Unhack glib
${utillinux.rules['install']}
#	(sed -i~ -e "s;$(ROOTFS_DIR)/usr;/usr;" $(ROOTFS_DIR)/usr/lib/libglib-2.0.la);

#Add to targets	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_UTIL-LINUX_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}
.NOTPARALLEL: