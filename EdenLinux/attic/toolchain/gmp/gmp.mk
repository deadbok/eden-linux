GMP_VERSION := 4.3.1
GMP_FILE := gmp-$(GMP_VERSION).tar.bz2
GMP_URL := ftp://ftp.gmplib.org/pub/gmp-4.3.1/$(GMP_FILE)

$(DLDIR)/$(GMP_FILE):
	$(WGET) $(GMP_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/configure: $(DLDIR)/$(GMP_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(GMP_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION); \
		LDFLAGS=$(LDFLAGS) ./configure --prefix=$(TOOLCHAIN_ROOT_DIR) \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/libgmp.la: $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)

$(TOOLCHAIN_ROOT_DIR)/lib/libgmp.a: $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION)/libgmp.la
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION) install
		
gmp-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION) clean

gmp-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gmp-$(GMP_VERSION) distclean
	
gmp-target: linux_headers-target $(TOOLCHAIN_ROOT_DIR)/lib/libgmp.a
	
TOOLCHAIN_TARGETS += gmp-target
CLEAN_TARGETS += gmp-clean
DISTCLEAN_TARGTETS += gmp-distclean
