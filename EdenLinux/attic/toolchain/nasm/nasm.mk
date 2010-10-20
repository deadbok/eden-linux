NASM_VERSION := 2.08.02
NASM_FILE := nasm-$(NASM_VERSION).tar.bz2
NASM_URL := http://www.nasm.us/pub/nasm/releasebuilds/$(NASM_VERSION)/$(NASM_FILE)

$(DLDIR)/$(NASM_FILE):
	$(WGET) $(NASM_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/configure: $(DLDIR)/$(NASM_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(NASM_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION); \
		./configure --prefix=$(TOOLCHAIN_ROOT_DIR) \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/nasm: $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)

$(TOOLCHAIN_ROOT_DIR)/bin/nasm: $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION)/nasm
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION) install
		
nasm-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION) clean

nasm-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/nasm-$(NASM_VERSION) distclean
	
nasm-target: $(TOOLCHAIN_ROOT_DIR)/bin/nasm
	
TOOLCHAIN_TARGETS += nasm-target
CLEAN_TARGETS += nasm-clean
DISTCLEAN_TARGTETS += nasm-distclean
