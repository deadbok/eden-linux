UCLIBC_VERSION := 0.9.31
UCLIBC_FILE := uClibc-$(UCLIBC_VERSION).tar.bz2
UCLIBC_URL := http://www.uclibc.org/downloads/$(UCLIBC_FILE)

$(DLDIR)/$(UCLIBC_FILE):
	$(WGET) $(UCLIBC_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION)/.config: $(DLDIR)/$(UCLIBC_FILE) $(TOOLCHAIN_DIR)/uClibc/config
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(UCLIBC_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	patch -p1 -d $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) < $(TOOLCHAIN_DIR)/uClibc/avoid-divdi3.patch
	patch -p1 -d $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) < $(TOOLCHAIN_DIR)/uClibc/sock_cloexec_nonblock.patch
	patch -p1 -d $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) < $(TOOLCHAIN_DIR)/uClibc/inotify_init1.patch
	patch -p1 -d $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) < $(TOOLCHAIN_DIR)/uClibc/endian_h.patch	
	cp $(TOOLCHAIN_DIR)/uClibc/config $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION)/.config

$(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION)/lib/libc.a: $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION)/.config
	PATH=$(TOOLCHAIN_PATH) $(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) oldconfig
	PATH=$(TOOLCHAIN_PATH) $(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) CROSS=$(EDEN_ARCH_TARGET)- \
	CC="$(EDEN_ARCH_TARGET)-gcc" KERNEL_HEADERS=$(ROOTFS)/usr/include RUNTIME_PREFIX="$(ROOTFS)/"

$(ROOTFS)/usr/lib/libc.a: $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION)/lib/libc.a
	PATH=$(TOOLCHAIN_PATH) $(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) PREFIX=$(ROOTFS)/ install
		
uclibc-clean:
	-PATH=$(TOOLCHAIN_PATH) $(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) clean

uclibc-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/uClibc-$(UCLIBC_VERSION) distclean
	
uclibc-target: gcc-static-target $(ROOTFS)/usr/lib/libc.a
	
TOOLCHAIN_TARGETS += uclibc-target
CLEAN_TARGETS += uclibc-clean
DISTCLEAN_TARGTETS += uclibc-distclean
