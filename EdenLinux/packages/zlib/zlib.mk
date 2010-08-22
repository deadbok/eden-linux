ZLIB_VERSION := 1.2.5
ZLIB_FILE := zlib-$(ZLIB_VERSION).tar.gz
ZLIB_URL := http://www.zlib.net/$(ZLIB_FILE)

$(DLDIR)/$(ZLIB_FILE):
	$(WGET) $(ZLIB_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/configure: $(DLDIR)/$(ZLIB_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(ZLIB_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/configure

$(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/Makefile: $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/configure
	(cd $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION); \
		$(TOOLCHAIN) ./configure \
		--prefix=/usr \
		--shared; \
		cd .. \
	);
	
$(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/libz.a: $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)

$(ROOTFS)/usr/lib/libz.a: $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION)/libz.a
	$(MAKE) -C $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION) prefix=$(ROOTFS)/usr install
		
zlib-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION) clean

zlib-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/zlib-$(ZLIB_VERSION) distclean
	
zlib-target: $(ROOTFS)/usr/lib/libz.a
	
TARGETS += zlib-target
CLEAN_TARGETS += zlib-clean
DISTCLEAN_TARGTETS += zlib-distclean
