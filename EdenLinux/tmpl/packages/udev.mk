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

#Device skeleton for udev
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

$(ROOTFS_DIR)/lib/udev/devices/tty2: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty2 c 4 2
	
$(ROOTFS_DIR)/lib/udev/devices/tty3: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty3 c 4 3
	
$(ROOTFS_DIR)/lib/udev/devices/tty4: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty4 c 4 4
	
$(ROOTFS_DIR)/lib/udev/devices/tty5: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty5 c 4 5
	
$(ROOTFS_DIR)/lib/udev/devices/tty6: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/tty6 c 4 5
	
$(ROOTFS_DIR)/lib/udev/devices/console: $(ROOTFS_DIR)/lib/udev/devices
	-$(MKNOD) $(ROOTFS_DIR)/lib/udev/devices/console c 5 1

${local()}DEVICES =  $(ROOTFS_DIR)/lib/udev/devices/zero $(ROOTFS_DIR)/lib/udev/devices/null 
${local()}DEVICES += $(ROOTFS_DIR)/lib/udev/devices/tty $(ROOTFS_DIR)/lib/udev/devices/tty0
${local()}DEVICES += $(ROOTFS_DIR)/lib/udev/devices/tty1 $(ROOTFS_DIR)/lib/udev/devices/tty2 
${local()}DEVICES += $(ROOTFS_DIR)/lib/udev/devices/tty3 $(ROOTFS_DIR)/lib/udev/devices/tty4 
${local()}DEVICES += $(ROOTFS_DIR)/lib/udev/devices/tty5 $(ROOTFS_DIR)/lib/udev/devices/tty6 
${local()}DEVICES += $(ROOTFS_DIR)/lib/udev/devices/console

${py udev = AutoconfPackage('$(PACKAGES_BUILD_DIR)/udev-$(PACKAGES_UDEV_VERSION)', '', '168', "http://launchpad.net/udev/main/168/+download/udev-$(PACKAGES_UDEV_VERSION).tar.bz2", "$(ROOTFS_DIR)/sbin/udevd")}

${udev.vars()}

${udev.rules['download']}

${udev.rules['unpack']}

${udev.rules['config']}

${udev.rules['build']}

${py udev.rules['install'].dependencies += ' $(PACKAGES_UDEV_DEVICES)'}
${udev.rules['install']}
	$(CP) -R $(ROOT)/${namespace.current.replace(".", "/")}/etc $(ROOTFS_DIR)/
	$(CHMOD) 754 $(ROOTFS_DIR)/etc/init.d/udev
	$(CHMOD) 754 $(ROOTFS_DIR)/etc/init.d/udev-mount
	#Link the service to openrc's boot run level
	$(LN) -sf ../../init.d/udev $(ROOTFS_DIR)/etc/runlevels/boot/udev
	$(LN) -sf ../../init.d/udev-mount $(ROOTFS_DIR)/etc/runlevels/boot/udev-mount

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_UDEV_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_UDEV_INSTALL)
PACKAGES_NAME_TARGETS += udev