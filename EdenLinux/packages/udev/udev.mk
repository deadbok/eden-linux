UDEV_VERSION := 161
UDEV_FILE := udev-$(UDEV_VERSION).tar.bz2
UDEV_URL := http://www.kernel.org/pub/linux/utils/kernel/hotplug/$(UDEV_FILE)

$(DLDIR)/$(UDEV_FILE):
	$(WGET) $(UDEV_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/configure: $(DLDIR)/$(UDEV_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(UDEV_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/configure

$(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/Makefile: $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/configure
	(cd $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION); \
		$(TOOLCHAIN) ./configure --prefix=/usr --target=$(EDEN_ARCH_TARGET) \
  		--host=$(EDEN_ARCH_TARGET) --disable-extras --disable-introspection \
  		--disable-gtk-doc-html --datarootdir=$(ROOTFS)/usr/share \
  		--libexecdir=/lib/udev --sbindir=/sbin --sysconfdir=/etc --libexecdir=$(ROOTFS)/etc/udev; \
		cd .. \
	);
	
$(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/udev/udevd: $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) CROSS_COMPILE=$(EDEN_ARCH_TARGET)- CC="$(EDEN_ARCH_TARGET)-gcc" LD="$(EDEN_ARCH_TARGET)-gcc" -C $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)

$(ROOTFS)/sbin/udevd: $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION)/udev/udevd
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION) DESTDIR=$(ROOTFS) install
	$(CP) $(PACKAGE_DIR)/udev/80-drivers.rules $(ROOTFS)/etc/udev/rules.d/80-drivers.rules
		
udev-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION) clean

udev-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/udev-$(UDEV_VERSION) distclean
	
udev-target: $(ROOTFS)/sbin/udevd
	
TARGETS += udev-target
CLEAN_TARGETS += udev-clean
DISTCLEAN_TARGTETS += udev-distclean
