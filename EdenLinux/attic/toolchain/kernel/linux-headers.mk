#$(TOOLCHAIN_ROOT_DIR)/include/linux/version.h: $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/Makefile
#	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) mrproper
#	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) headers_check
#	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) INSTALL_HDR_PATH=$(TOOLCHAIN_ROOT_DIR) headers_install

$(ROOTFS)/usr/include/linux/version.h: $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/Makefile
	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) mrproper
	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) headers_check
	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) INSTALL_HDR_PATH=$(ROOTFS)/usr headers_install

linux_headers-target: $(ROOTFS)/usr/include/linux/version.h

linux_headers-clean:
	rm $(TOOLCHAIN_ROOT_DIR)/include
	
linux_headers-distclean: linux_headers-clean

TOOLCHAIN_TARGETS += linux_headers-target
CLEAN_TARGETS += linux_headers-clean
DISTCLEAN_TARGTETS += linux_headers-distclean
