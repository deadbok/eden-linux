GRUB_VERSION := 0.97
GRUB_FILE := grub-$(GRUB_VERSION).tar.gz
GRUB_URL := ftp://alpha.gnu.org/gnu/grub/$(GRUB_FILE)

$(DLDIR)/$(GRUB_FILE):
	$(WGET) $(GRUB_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/configure: $(DLDIR)/$(GRUB_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(GRUB_FILE) -C $(ARCH_BUILD_DIR)
	patch -p1 -d $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION) < $(PACKAGE_DIR)/grub/grub-0.97-limits_h.patch
	touch $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/configure

$(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/Makefile: $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/configure
	(cd $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION); \
		$(TOOLCHAIN) ./configure \
		--prefix=/usr \
		--target=$(EDEN_ARCH_TARGET) --host=$(EDEN_ARCH_TARGET) \
		--with-cc="$(CC)" \
		--with-linker=$(LD) \
	);
	
$(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/grub/grub: $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)

$(ROOTFS)/usr/sbin/grub: $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION)/grub/grub
	$(MAKE) -C $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION) DESTDIR=$(ROOTFS) install
	mkdir -p $(ROOTFS)/boot/grub
	cp $(VERBOSE_FLAG) $(ROOTFS)/usr/lib/grub/i386-pc/* $(ROOTFS)/boot/grub
	
$(ROOTFS)/boot/grub/menu.lst:
	mkdir -p $(ROOTFS)/boot/grub
	echo -e "default 0\ntimeout 5\ntitle=EdenLinux \nroot (hd0,0) \nkernel /boot/kernel-$(KERNEL_VERSION) root=/dev/sda1\n" > $(ROOTFS)/boot/grub/menu.lst

grub-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION) clean

grub-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/grub-$(GRUB_VERSION) distclean
	
grub-target: $(ROOTFS)/usr/sbin/grub $(ROOTFS)/boot/grub/menu.lst

CLEAN_TARGETS += grub-clean
DISTCLEAN_TARGTETS += grub-distclean
