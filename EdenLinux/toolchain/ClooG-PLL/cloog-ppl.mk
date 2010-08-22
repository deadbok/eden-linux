CLOOG-PLL_VERSION := 0.15.7
CLOOG-PLL_FILE := cloog-ppl-$(CLOOG-PLL_VERSION).tar.gz
CLOOG-PLL_URL := ftp://gcc.gnu.org/pub/gcc/infrastructure/$(CLOOG-PLL_FILE)

$(DLDIR)/$(CLOOG-PLL_FILE):
	$(WGET) $(CLOOG-PLL_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/configure: $(DLDIR)/$(CLOOG-PLL_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(CLOOG-PLL_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION); \
		LDFLAGS=$(LDFLAGS) ./configure --prefix=$(TOOLCHAIN_ROOT_DIR) --enable-shared --with-bits=gmp \
    	--with-gmp=$(TOOLCHAIN_ROOT_DIR) --with-ppl=$(TOOLCHAIN_ROOT_DIR) \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/libcloog.la: $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)

$(TOOLCHAIN_ROOT_DIR)/lib/libcloog.a: $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION)/libcloog.la
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION) install
		
cloog-ppl-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION) clean

cloog-ppl-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/cloog-ppl-$(CLOOG-PLL_VERSION) distclean
	
cloog-ppl-target: $(TOOLCHAIN_ROOT_DIR)/lib/libcloog.a
	
#TOOLCHAIN_TARGETS += cloog-ppl-target
#CLEAN_TARGETS += cloog-ppl-clean
#DISTCLEAN_TARGTETS += cloog-ppl-distclean
