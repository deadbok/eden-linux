BINUTILS_VERSION := 2.19.1
BINUTILS_FILE := binutils-$(BINUTILS_VERSION).tar.bz2
BINUTILS_URL := ftp://gcc.gnu.org/pub/binutils/releases/$(BINUTILS_FILE)

$(DLDIR)/$(BINUTILS_FILE):
	$(WGET) $(BINUTILS_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/binutils-$(BINUTILS_VERSION)/configure: $(DLDIR)/$(BINUTILS_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(BINUTILS_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/binutils-$(BINUTILS_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/binutils-build/Makefile: $(TOOLCHAIN_BUILD_DIR)/binutils-$(BINUTILS_VERSION)/configure
	(mkdir $(TOOLCHAIN_BUILD_DIR)/binutils-build; \
	cd $(TOOLCHAIN_BUILD_DIR)/binutils-build; \
		LDFLAGS=$(LDFLAGS) $(TOOLCHAIN_BUILD_DIR)/binutils-$(BINUTILS_VERSION)/configure \
		--prefix=$(TOOLCHAIN_ROOT_DIR) --build=$(EDEN_BUILD_HOST) \
		--target=$(EDEN_ARCH_TARGET) --with-sysroot=$(ROOTFS) \
   		--disable-nls --enable-shared --disable-multilib \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/binutils-build/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/binutils-build/binutils/readelf: $(TOOLCHAIN_BUILD_DIR)/binutils-build/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/binutils-build configure-host
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/binutils-build

$(TOOLCHAIN_ROOT_DIR)/bin/$(EDEN_ARCH_TARGET)-readelf: $(TOOLCHAIN_BUILD_DIR)/binutils-build/binutils/readelf
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/binutils-build install
		
binutils-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/binutils-build clean

binutils-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/binutils-build distclean
	
binutils-target: mpfr-target $(TOOLCHAIN_ROOT_DIR)/bin/$(EDEN_ARCH_TARGET)-readelf
	
TOOLCHAIN_TARGETS += binutils-target
CLEAN_TARGETS += binutils-clean
DISTCLEAN_TARGTETS += binutils-distclean
