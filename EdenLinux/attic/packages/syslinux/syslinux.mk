#This link has a lot of useful info about cross compiling syslinux
#	http://trac.cross-lfs.org/wiki/bootloaders/syslinux

SYSLINUX_VERSION := 4.02
SYSLINUX_FILE := syslinux-$(SYSLINUX_VERSION).tar.bz2
SYSLINUX_URL := http://www.kernel.org/pub/linux/utils/boot/syslinux/$(SYSLINUX_FILE)

$(DLDIR)/$(SYSLINUX_FILE):
	$(WGET) $(SYSLINUX_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/Makefile: $(DLDIR)/$(SYSLINUX_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(SYSLINUX_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/Makefile

$(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/MCONFIG: $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/Makefile
	$(CP) $(PACKAGE_DIR)/syslinux/MCONFIG $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/MCONFIG
	
$(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/extlinux/extlinux: $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/MCONFIG
	$(TOOLCHAIN) $(MAKE) CROSS_COMPILE=$(EDEN_ARCH_TARGET)- -C $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION) installer

$(ROOTFS)/boot/extlinux.conf:
	$(CP)  $(PACKAGE_DIR)/syslinux/extlinux.conf $(ROOTFS)/boot/extlinux.conf	
	
syslinux-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION) clean

syslinux-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION) distclean
	
syslinux-target: nasm-target $(ARCH_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/extlinux/extlinux 

CLEAN_TARGETS += syslinux-clean
DISTCLEAN_TARGTETS += syslinux-distclean
