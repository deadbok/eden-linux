$(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/configure: $(DLDIR)/$(GRUB_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(GRUB_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	patch -p 1 -d $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) < $(PACKAGE_DIR)/grub/grub-0.97-limits_h.patch
	patch -p 1 -d $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) < $(PACKAGE_DIR)/grub/grub-0.97-cvs-sync.patch
	patch -p 1 -d $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) < $(TOOLCHAIN_DIR)/grub/grub_0.97-47lenny2.diff
	patch -p 1 -d $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) < $(TOOLCHAIN_DIR)/grub/fix-variadic.patch
	touch $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/Makefile: $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/configure
	(cd $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION); \
		aclocal && automake && autoconf && ./configure --disable-werror \
		--prefix=$(TOOLCHAIN_ROOT_DIR) \
	);
	
$(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/grub/grub: $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)

$(TOOLCHAIN_ROOT_DIR)/sbin/grub: $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION)/grub/grub
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) install

toolchain-grub-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) clean

toolchain-grub-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/grub-$(GRUB_VERSION) distclean
	
toolchain-grub-target: $(TOOLCHAIN_ROOT_DIR)/sbin/grub
	
CLEAN_TARGETS += toolchain-grub-clean
DISTCLEAN_TARGTETS += toolchain-grub-distclean
