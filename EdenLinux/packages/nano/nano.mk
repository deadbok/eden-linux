NANO_VERSION := 2.2.5
NANO_FILE := nano-$(NANO_VERSION).tar.gz
NANO_URL := http://www.nano-editor.org/dist/v2.2/$(NANO_FILE)

$(DLDIR)/$(NANO_FILE):
	$(WGET) $(NANO_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/configure.in: $(DLDIR)/$(NANO_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(NANO_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/configure.in

$(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/Makefile: $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/configure.in
	(cd $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION); \
		$(TOOLCHAIN) ./configure --prefix=/usr --target=$(EDEN_ARCH_TARGET)\
  		--host=$(EDEN_ARCH_TARGET) --enable-tiny --program-prefix=);
	
$(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/src/nano: $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)

$(ROOTFS)/usr/bin/nano: $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION)/src/nano
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION) DESTDIR=$(ROOTFS) install
		
nano-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION) distclean

nano-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/nano-$(NANO_VERSION) distclean
	
nano-target: ncurses-target $(ROOTFS)/usr/bin/nano
	
TARGETS += nano-target
CLEAN_TARGETS += nano-clean
DISTCLEAN_TARGTETS += nano-distclean
