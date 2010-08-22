E2FSIMAGE_VERSION := 0.2.2
E2FSIMAGE_FILE := e2fsimage-$(E2FSIMAGE_VERSION).tar.gz
E2FSIMAGE_URL := http://dfn.dl.sourceforge.net/sourceforge/e2fsimage/$(E2FSIMAGE_FILE)

$(DLDIR)/$(E2FSIMAGE_FILE):
	$(WGET) $(E2FSIMAGE_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/configure: $(DLDIR)/$(E2FSIMAGE_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(E2FSIMAGE_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION); \
		prefix=$(TOOLCHAIN_ROOT_DIR)/ ./configure \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/src/e2fsimage: $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)

$(TOOLCHAIN_ROOT_DIR)/bin/e2fsimage: $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION)/src/e2fsimage
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION) install
		
e2fsimage-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION) clean

e2fsimage-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/e2fsimage-$(E2FSIMAGE_VERSION) distclean
	
e2fsimage-target: $(TOOLCHAIN_ROOT_DIR)/bin/e2fsimage
	
#TOOLCHAIN_TARGETS += e2fsimage-target
CLEAN_TARGETS += e2fsimage-clean
DISTCLEAN_TARGTETS += e2fsimage-distclean
