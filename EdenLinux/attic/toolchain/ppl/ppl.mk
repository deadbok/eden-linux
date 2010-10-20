PPL_VERSION := 0.10.2
PPL_FILE := ppl-$(PPL_VERSION).tar.bz2
PPL_URL := ftp://ftp.cs.unipr.it/pub/ppl/releases/0.10.2/$(PPL_FILE)

$(DLDIR)/$(PPL_FILE):
	$(WGET) $(PPL_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/configure: $(DLDIR)/$(PPL_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(PPL_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION); \
		LDFLAGS=$(LDFLAGS) ./configure --prefix=$(TOOLCHAIN_ROOT_DIR) --enable-shared \
		--enable-interfaces="c,cxx" --disable-optimization \
		--with-libgmp-prefix=$(TOOLCHAIN_ROOT_DIR) \
		--with-libgmpxx-prefix=$(TOOLCHAIN_ROOT_DIR) \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/src/libppl.la: $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)

$(TOOLCHAIN_ROOT_DIR)/lib/libppl.a: $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION)/src/libppl.la
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION) install
		
ppl-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION) clean

ppl-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/ppl-$(PPL_VERSION) distclean
	
ppl-target: $(TOOLCHAIN_ROOT_DIR)/lib/libppl.a
	
#TOOLCHAIN_TARGETS += ppl-target
#CLEAN_TARGETS += ppl-clean
#DISTCLEAN_TARGTETS += ppl-distclean
