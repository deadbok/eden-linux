$(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/Makefile: $(DLDIR)/$(SYSLINUX_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(SYSLINUX_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/extlinux/extlinux: $(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) CROSS_COMPILE=$(EDEN_ARCH_TARGET)- -C $(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION) installer
		
toolchain-syslinux-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION) clean

toolchain-syslinux-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION) distclean
	
toolchain-syslinux-target: nasm-target $(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/extlinux/extlinux 
	
CLEAN_TARGETS += toolchain-syslinux-clean
DISTCLEAN_TARGTETS += toolchain-syslinux-distclean
