BUSYBOX_VERSION := 1.17.1
BUSYBOX_FILE := busybox-$(BUSYBOX_VERSION).tar.bz2
BUSYBOX_URL := http://busybox.net/downloads/$(BUSYBOX_FILE)

$(DLDIR)/$(BUSYBOX_FILE):
	$(WGET) $(BUSYBOX_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/Makefile: $(DLDIR)/$(BUSYBOX_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(BUSYBOX_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/Makefile

$(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/.config: $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/Makefile
	$(CP) $(PACKAGE_DIR)/busybox/config $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/.config
	
$(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/busybox: $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/.config
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION) oldconfig
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION) ARCH=$(EDEN_ARCH) \
	CROSS_COMPILE=$(EDEN_ARCH_TARGET)- CC="$(EDEN_ARCH_TARGET)-gcc" 

$(ROOTFS)/bin/busybox: $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/busybox
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION) install CONFIG_PREFIX=$(ROOTFS) \
	CROSS_COMPILE=$(EDEN_ARCH_TARGET)- ARCH=$(EDEN_ARCH) CC="$(EDEN_ARCH_TARGET)-gcc"

$(ROOTFS)/sbin/depmod.pl: $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/Makefile
	$(CP) $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/examples/depmod.pl $(ROOTFS)/sbin/depmod.pl
	chmod 755 $(ROOTFS)/sbin/depmod.pl

$(ROOTFS)/etc/network/udhcpc.script: $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/Makefile $(ROOTFS)/etc/network
	$(CP) $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION)/examples/udhcp/simple.script $(ROOTFS)/etc/network/udhcpc.script
		
busybox-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION) clean

busybox-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/busybox-$(BUSYBOX_VERSION) distclean
	
busybox-target: $(ROOTFS)/bin/busybox $(ROOTFS)/sbin/depmod.pl $(ROOTFS)/etc/network/udhcpc.script
	
TARGETS += busybox-target
CLEAN_TARGETS += busybox-clean
DISTCLEAN_TARGTETS += busybox-distclean
