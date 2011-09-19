#mtl
${local_namespace("packages.udev")}

${package("$(PACKAGES_BUILD_DIR)/udev-$(PACKAGES_UDEV_VERSION)", "", "168", "udev-$(PACKAGES_UDEV_VERSION).tar.bz2", "http://linux-kernel.uio.no/pub/linux/utils/kernel/hotplug/$(PACKAGES_UDEV_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_UDEV_SRC_DIR)/configure")}
	
${autoconf('$(PACKAGES_ENV)', '--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --disable-extras --disable-introspection --disable-gtk-doc-html --datarootdir=/usr/share --libexecdir=/lib/udev --sbindir=/sbin --sysconfdir=/etc', "")}

${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" LD="$(ARCH_TARGET)-gcc"', "all", "$(PACKAGES_UDEV_BUILD_DIR)/udev/udevd", "$(PACKAGES_UDEV_CONFIG)")}

${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/sbin/udevd", "$(PACKAGES_UDEV_ALL)")}
	$(CP) $(ROOT)/${put(namespace.current.replace(".", "/"))}/80-drivers.rules $(ROOTFS_DIR)/etc/udev/rules.d/80-drivers.rules
	$(CP) $(ROOT)/${put(namespace.current.replace(".", "/"))}/udev $(ROOTFS_DIR)/etc/init.d/udev  

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

${local}DEVICES = $(ROOTFS_DIR)/lib/udev/devices/zero $(ROOTFS_DIR)/lib/udev/devices/null $(ROOTFS_DIR)/lib/udev/devices/tty $(ROOTFS_DIR)/lib/udev/devices/tty0 $(ROOTFS_DIR)/lib/udev/devices/tty1 $(ROOTFS_DIR)/lib/udev/devices/console
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
