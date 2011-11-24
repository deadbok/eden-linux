#mtl
${local_namespace("packages.udev")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" LD="$(ARCH_TARGET)-gcc"
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-extras --disable-introspection --disable-gtk-doc --disable-gtk-doc-html --datarootdir=$(ROOTFS_DIR)/usr/share --libexecdir=/lib/udev --sbindir=/sbin --sysconfdir=/etc
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

#Add udev to the list of init services
SERVICES += udev

${py udev = AutoconfPackage('$(PACKAGES_BUILD_DIR)/udev-$(PACKAGES_UDEV_VERSION)', '', '168', "http://launchpad.net/udev/main/168/+download/udev-$(PACKAGES_UDEV_VERSION).tar.bz2", "$(ROOTFS_DIR)/sbin/udevd")}

${udev.vars()}

${udev.rules['download']}

${udev.rules['unpack']}

${udev.rules['config']}

${udev.rules['build']}

${py udev.rules['install'].dependencies += " $(PACKAGES_BOOTSCRIPTS_INSTALL)"}
${udev.rules['install']}
	$(CP) $(ROOT)/${namespace.current.replace(".", "/")}/80-drivers.rules $(ROOTFS_DIR)/etc/udev/rules.d/80-drivers.rules
	$(CP) $(ROOT)/${namespace.current.replace(".", "/")}/udev $(ROOTFS_DIR)/etc/init.d/udev
	$(CHMOD) 754 $(ROOTFS_DIR)/etc/init.d/udev

#${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" LD="$(ARCH_TARGET)-gcc"', "all", "$(PACKAGES_UDEV_BUILD_DIR)/udev/udevd", "$(PACKAGES_UDEV_CONFIG)")}

#${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/sbin/udevd", "$(PACKAGES_UDEV_ALL) $(PACKAGES_BOOTSCRIPTS_INSTALL)")}
#	$(CP) $(ROOT)/${namespace.current.replace(".", "/")}/80-drivers.rules $(ROOTFS_DIR)/etc/udev/rules.d/80-drivers.rules
#	$(CP) $(ROOT)/${namespace.current.replace(".", "/")}/udev $(ROOTFS_DIR)/etc/init.d/udev  

$(ROOTFS_DIR)/lib/udev/devices:
	$(MKDIR) -p $(ROOTFS_DIR)/lib/udev/devices

$(ROOTFS_DIR)/lib/udev/devices/zero: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/zero c 1 5

$(ROOTFS_DIR)/lib/udev/devices/null: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/null c 1 3

$(ROOTFS_DIR)/lib/udev/devices/tty: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty c 5 0

$(ROOTFS_DIR)/lib/udev/devices/tty0: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty0 c 4 0

$(ROOTFS_DIR)/lib/udev/devices/tty1: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty1 c 4 1

$(ROOTFS_DIR)/lib/udev/devices/console: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/console c 5 1

${local()}DEVICES = $(ROOTFS_DIR)/lib/udev/devices/zero $(ROOTFS_DIR)/lib/udev/devices/null $(ROOTFS_DIR)/lib/udev/devices/tty $(ROOTFS_DIR)/lib/udev/devices/tty0 $(ROOTFS_DIR)/lib/udev/devices/tty1 $(ROOTFS_DIR)/lib/udev/devices/console

#packages:
#	udev:
#		version = 162
#		dir = udev-${version}
#		group = basesystem
#		url = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev-${version}.tar.bz2
#		
#		SERVICES += udev
#
#		download()
#		unpack(${build_dir.packages}/${dir}/configure)
#		config(config_opts = "--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-extras --disable-introspection --disable-gtk-doc-html --datarootdir=/usr/share --libexecdir=/lib/udev --sbindir=/sbin --sysconfdir=/etc", ${build_dir.packages}/${dir}/Makefile, ${unpack})
#		build(${build_dir.packages}/${dir}/udev/udevd, make_opts="DESTDIR=$(ROOTFS_DIR) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" LD="$(ARCH_TARGET)-gcc"", ${build_dir.packages}/${dir}/Makefile)
#		install(make_opts="DESTDIR=$(ROOTFS_DIR)", $(ROOTFS_DIR)/sbin/udevd, ${build_dir.packages}/${dir}/udev/udevd ${install.bootscripts.packages})
#		{
#			${target}: ${dependencies} ${current_build_target} $(ROOTFS_DIR)/lib/udev/devices/zero $(ROOTFS_DIR)/lib/udev/devices/null $(ROOTFS_DIR)/lib/udev/devices/tty $(ROOTFS_DIR)/lib/udev/devices/tty0 $(ROOTFS_DIR)/lib/udev/devices/tty1 $(ROOTFS_DIR)/lib/udev/devices/console
#				${env_packages} ${make} -C ${current_package_dir} install ${make_opts}
#				${cp} ${root}/${package_file_dir}/80-drivers.rules $(ROOTFS_DIR)/etc/udev/rules.d/80-drivers.rules
#				${cp} ${root}/${package_file_dir}/udev $(ROOTFS_DIR)/etc/init.d/udev
#			
#			$(ROOTFS_DIR)/lib/udev/devices:
#				${mkdir} -p $(ROOTFS_DIR)/lib/udev/devices
#				
#			$(ROOTFS_DIR)/lib/udev/devices/zero: $(ROOTFS_DIR)/lib/udev/devices
#				-mknod $(ROOTFS_DIR)/lib/udev/devices/zero c 1 5
#
#			$(ROOTFS_DIR)/lib/udev/devices/null: $(ROOTFS_DIR)/lib/udev/devices
#				-mknod $(ROOTFS_DIR)/lib/udev/devices/null c 1 3
#			
#			$(ROOTFS_DIR)/lib/udev/devices/tty: $(ROOTFS_DIR)/lib/udev/devices
#				-mknod $(ROOTFS_DIR)/lib/udev/devices/tty c 5 0
#			
#			$(ROOTFS_DIR)/lib/udev/devices/tty0: $(ROOTFS_DIR)/lib/udev/devices
#				-mknod $(ROOTFS_DIR)/lib/udev/devices/tty0 c 4 0
#				
#			$(ROOTFS_DIR)/lib/udev/devices/tty1: $(ROOTFS_DIR)/lib/udev/devices
#				-mknod $(ROOTFS_DIR)/lib/udev/devices/tty1 c 4 1
#
#			$(ROOTFS_DIR)/lib/udev/devices/console: $(ROOTFS_DIR)/lib/udev/devices
#				-mknod $(ROOTFS_DIR)/lib/udev/devices/console c 5 1				
#		}
#		clean()
#		distclean()
#	:udev
#:packages
