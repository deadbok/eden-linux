$(TOOLCHAIN_BUILD_DIR)/gcc-cross-build/Makefile: $(TOOLCHAIN_BUILD_DIR)/gcc-$(GCC_VERSION)/configure
	(mkdir $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build; \
	cd $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build; \
		LDFLAGS=$(LDFLAGS) $(TOOLCHAIN_BUILD_DIR)/gcc-$(GCC_VERSION)/configure \
		--prefix=$(TOOLCHAIN_ROOT_DIR) --host=$(EDEN_BUILD_HOST) \
		--target=$(EDEN_ARCH_TARGET) --with-sysroot=$(ROOTFS) \
   		--disable-nls --enable-shared --disable-multilib \
   		--build=$(EDEN_BUILD_HOST) --enable-c99 \
	    --enable-long-long --with-mpfr=$(TOOLCHAIN_ROOT_DIR) \
	    --with-gmp=$(TOOLCHAIN_ROOT_DIR) --enable-languages=c,c++ \
	    --includedir=$(ROOTFS)/usr/include \
	);
	touch $(TOOLCHAIN_BUILD_DIR)/gcc-static-build/Makefile
	
$(TOOLCHAIN_BUILD_DIR)/gcc-cross-build/gcc/libgcc.a: $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build/Makefile
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build

$(TOOLCHAIN_ROOT_DIR)/bin/$(EDEN_ARCH_TARGET)-c++: $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build/gcc/libgcc.a
	$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build install
	
$(ROOTFS)/lib/libgcc_s.so: $(TOOLCHAIN_ROOT_DIR)/bin/$(EDEN_ARCH_TARGET)-c++
	$(CP) -R $(TOOLCHAIN_ROOT_DIR)/$(EDEN_ARCH_TARGET)/lib/* $(ROOTFS)/lib/
		
gcc-cross-clean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build clean

gcc-cross-distclean:
	-$(MAKE) -C $(TOOLCHAIN_BUILD_DIR)/gcc-cross-build distclean
	
gcc-cross-target: uclibc-target $(ROOTFS)/lib/libgcc_s.so
	
TOOLCHAIN_TARGETS += gcc-cross-target
CLEAN_TARGETS += gcc-cross-clean
DISTCLEAN_TARGTETS += gcc-cross-distclean
