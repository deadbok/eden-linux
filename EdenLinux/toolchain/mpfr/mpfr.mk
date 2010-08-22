MPFR_VERSION := 3.0.0
MPFR_FILE := mpfr-$(MPFR_VERSION).tar.bz2
MPFR_URL := http://www.mpfr.org/mpfr-current/$(MPFR_FILE)

$(DLDIR)/$(MPFR_FILE):
	$(WGET) $(MPFR_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/configure: $(DLDIR)/$(MPFR_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(MPFR_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION); \
		LDFLAGS=$(LDFLAGS) ./configure --prefix=$(TOOLCHAIN_ROOT_DIR) \
		--enable-shared --with-gmp=$(TOOLCHAIN_ROOT_DIR) \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/libmpfr.la: $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)

$(TOOLCHAIN_ROOT_DIR)/lib/libmpfr.a: $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION)/libmpfr.la
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION) install
		
mpfr-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION) clean

mpfr-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/mpfr-$(MPFR_VERSION) distclean
	
mpfr-target: gmp-target $(TOOLCHAIN_ROOT_DIR)/lib/libmpfr.a
	
TOOLCHAIN_TARGETS += mpfr-target
CLEAN_TARGETS += mpfr-clean
DISTCLEAN_TARGTETS += mpfr-distclean
