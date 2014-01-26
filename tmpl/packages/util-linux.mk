#mtl
${local_namespace("packages.util-linux")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --host=$(ARCH_TARGET) --disable-libuuid --disable-losetup --disable-cytune --disable-fsck --disable-partx --disable-uuidd --disable-mountpoint --disable-fallocate --disable-unshare --disable-nsenter --disable-setpriv --disable-eject --disable-agetty --disable-cramfs --disable-bfs --disable-fdformat --disable-hwclock --disable-wdctl --disable-switch_root --disable-pivot_root --disable-kill --disable-last --disable-utmpdump --disable-utmpdump --disable-mesg --disable-raw --disable-rename --disable-login --disable-nologin --disable-sulogin --disable-su --disable-runuser --disable-ul --disable-more --disable-pg --disable-setterm --disable-schedutils --disable-wall --disable-bash-completion
${local()}CONFIG_ENV = $(PACKAGES_ENV) scanf_cv_alloc_modifier=as

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py utillinux = AutoconfPackage('$(PACKAGES_BUILD_DIR)/util-linux-$(PACKAGES_UTIL-LINUX_VERSION)', '', '2.24.1', "http://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-$(PACKAGES_UTIL-LINUX_VERSION).tar.xz", "$(ROOTFS_DIR)/sbin/swapon")}

#Inset autogen call
${py utillinux.rules['config'].recipe.insert(2, '($(CD) $(PACKAGES_UTIL-LINUX_BUILD_DIR); ./autogen.sh); ')}

${utillinux}

#Add to targets	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_UTIL-LINUX_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}
.NOTPARALLEL: