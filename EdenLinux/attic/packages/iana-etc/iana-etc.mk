IANA-ETC_VERSION := 2.30
IANA-ETC_FILE := iana-etc-$(IANA-ETC_VERSION).tar.bz2
IANA-ETC_URL := http://sethwklein.net/$(IANA-ETC_FILE)

$(DLDIR)/$(IANA-ETC_FILE):
	$(WGET) $(IANA-ETC_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION)/Makefile: $(DLDIR)/$(IANA-ETC_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(IANA-ETC_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION)/Makefile

$(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION)/services: $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION)/Makefile
	$(MAKE) -C $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION)
	
$(ROOTFS)/etc/services: $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION)/services
	$(MAKE) -C $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION) install DESTDIR=$(ROOTFS)	
		
iana-etc-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION) clean

iana-etc-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/iana-etc-$(IANA-ETC_VERSION) distclean
	
iana-etc-target: $(ROOTFS)/etc/services
	
TARGETS += iana-etc-target
CLEAN_TARGETS += iana-etc-clean
DISTCLEAN_TARGTETS += iana-etc-distclean
