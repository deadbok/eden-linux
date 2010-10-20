KERNEL_VERSION := 2.6.30
KERNEL_FILE := linux-$(KERNEL_VERSION).tar.bz2
KERNEL_URL := ftp://ftp.dk.kernel.org/pub/linux/kernel/v2.6/$(KERNEL_FILE)

$(DLDIR)/$(KERNEL_FILE):
	$(WGET) $(KERNEL_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/Makefile: $(DLDIR)/$(KERNEL_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(KERNEL_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/Makefile

$(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/.config: $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/Makefile
	$(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) mrproper
	$(CP) $(PACKAGE_DIR)/kernel/config $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/.config
	
$(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/vmlinux: $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/.config
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) \
	CROSS_COMPILE=$(EDEN_ARCH_TARGET)- oldconfig
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) \
	CROSS_COMPILE=$(EDEN_ARCH_TARGET)-

# For testing the kernel with QEMU
.PHONY: kernel-floppy
kernel-floppy:
	$(TOOLCHAIN) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) ARCH=$(EDEN_KERNEL_ARCH) \
	CROSS_COMPILE=$(EDEN_ARCH_TARGET)- fdimage

$(ROOTFS)/lib/modules/$(KERNEL_VERSION): $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/vmlinux
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION) modules_install ARCH=$(EDEN_KERNEL_ARCH) \
	INSTALL_MOD_PATH=$(ROOTFS) CROSS_COMPILE=$(EDEN_ARCH_TARGET)-

$(ROOTFS)/boot/kernel-$(KERNEL_VERSION): $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/vmlinux
	$(CP) $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/System.map $(ROOTFS)/boot/System.map-$(KERNEL_VERSION)
	$(CP) $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/arch/x86/boot/bzImage $(ROOTFS)/boot/kernel-$(KERNEL_VERSION)
	$(CP) $(ARCH_BUILD_DIR)/linux-$(KERNEL_VERSION)/.config $(ROOTFS)/boot/config-$(KERNEL_VERSION)
	$(ROOTFS)/sbin/depmod.pl -F $(ROOTFS)/boot/System.map-$(KERNEL_VERSION) \
    -b $(ROOTFS)/lib/modules/$(KERNEL_VERSION)
	
	
kernel-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/kernel-$(KERNEL_VERSION) clean

kernel-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/kernel-$(KERNEL_VERSION) distclean
	
kernel-target: $(ROOTFS)/lib/modules/$(KERNEL_VERSION) $(ROOTFS)/boot/kernel-$(KERNEL_VERSION) 
	
TARGETS += kernel-target
CLEAN_TARGETS += kernel-clean
DISTCLEAN_TARGTETS += kernel-distclean
