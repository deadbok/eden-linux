GCC_VERSION := 4.4.1
GCC_FILE := gcc-$(GCC_VERSION).tar.bz2
GCC_URL := ftp://gcc.gnu.org/pub/gcc/releases/gcc-$(GCC_VERSION)/$(GCC_FILE)

$(DLDIR)/$(GCC_FILE):
	$(WGET) $(GCC_URL) -P $(DLDIR)

$(TOOLCHAIN_BUILD_DIR)/gcc-$(GCC_VERSION)/configure: $(DLDIR)/$(GCC_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(GCC_FILE) -C $(TOOLCHAIN_BUILD_DIR)
	touch $(TOOLCHAIN_BUILD_DIR)/gcc-$(GCC_VERSION)/configure

$(TOOLCHAIN_BUILD_DIR)/gcc-static-build/Makefile: $(TOOLCHAIN_BUILD_DIR)/gcc-$(GCC_VERSION)/configure
	(mkdir $(TOOLCHAIN_BUILD_DIR)/gcc-static-build; \
	cd $(TOOLCHAIN_BUILD_DIR)/gcc-static-build; \
		AR=ar LDFLAGS=$(LDFLAGS) $(TOOLCHAIN_BUILD_DIR)/gcc-$(GCC_VERSION)/configure \
		--prefix=$(TOOLCHAIN_ROOT_DIR) --with-newlib\
		--target=$(EDEN_ARCH_TARGET) --with-sysroot=$(ROOTFS) \
   		--disable-nls --disable-shared --disable-multilib \
	    --disable-libmudflap --disable-libssp --without-headers \
	    --with-mpfr=$(TOOLCHAIN_ROOT_DIR) --with-gmp=$(TOOLCHAIN_ROOT_DIR) \
	    --enable-languages=c --build=$(EDEN_BUILD_HOST) \
	    --disable-decimal-float --disable-libgomp --disable-threads \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/gcc-static-build/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/gcc-static-build/gcc/libgcc.a: $(TOOLCHAIN_BUILD_DIR)/gcc-static-build/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-static-build all-gcc all-target-libgcc

$(TOOLCHAIN_ROOT_DIR)/bin/$(EDEN_ARCH_TARGET)-gcc: $(TOOLCHAIN_BUILD_DIR)/gcc-static-build/gcc/libgcc.a
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-static-build install-gcc install-target-libgcc
		
gcc-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-static-build clean

gcc-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-static-build distclean
	
gcc-static-target: binutils-target $(TOOLCHAIN_ROOT_DIR)/bin/$(EDEN_ARCH_TARGET)-gcc
	
TOOLCHAIN_TARGETS += gcc-static-target
CLEAN_TARGETS += gcc-clean
DISTCLEAN_TARGTETS += gcc-distclean
