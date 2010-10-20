E2FSPROGS_VERSION := 1.41.6
E2FSPROGS_FILE := e2fsprogs-$(E2FSPROGS_VERSION).tar.gz
E2FSPROGS_URL := http://dfn.dl.sourceforge.net/sourceforge/e2fsprogs/$(E2FSPROGS_FILE)

$(DLDIR)/$(E2FSPROGS_FILE):
	$(WGET) $(E2FSPROGS_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/e2fsprogs-$(E2FSPROGS_VERSION)/configure: $(DLDIR)/$(E2FSPROGS_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(E2FSPROGS_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/e2fsprogs-$(E2FSPROGS_VERSION)/configure

$(ARCH_BUILD_DIR)/e2fsprogs-build/.dir:
	mkdir -p $(ARCH_BUILD_DIR)/e2fsprogs-build
	touch $(ARCH_BUILD_DIR)/e2fsprogs-build/.dir
	
$(ARCH_BUILD_DIR)/e2fsprogs-build/Makefile: $(ARCH_BUILD_DIR)/e2fsprogs-build/.dir $(ARCH_BUILD_DIR)/e2fsprogs-$(E2FSPROGS_VERSION)/configure
	(cd $(ARCH_BUILD_DIR)/e2fsprogs-build; \
		$(TOOLCHAIN) ../e2fsprogs-$(E2FSPROGS_VERSION)/configure \
		--prefix=/usr \
		--with-root-prefix="" \
		--host=$(EDEN_ARCH_TARGET) \
		--with-cc="$(CC)" \
		--with-linker=$(LD) \
		--disable-tls \
	);
	
$(ARCH_BUILD_DIR)/e2fsprogs-build/misc/mke2fs: $(ARCH_BUILD_DIR)/e2fsprogs-build/Makefile
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/e2fsprogs-build

$(ROOTFS)/sbin/mke2fs: $(ARCH_BUILD_DIR)/e2fsprogs-build/misc/mke2fs
	$(MAKE) -C $(ARCH_BUILD_DIR)/e2fsprogs-build DESTDIR=$(ROOTFS) install
	$(MAKE) -C $(ARCH_BUILD_DIR)/e2fsprogs-build DESTDIR=$(ROOTFS) install-libs

e2fsprogs-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/e2fsprogs-build clean

e2fsprogs-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/e2fsprogs-build distclean
	
e2fsprogs-target: $(ROOTFS)/sbin/mke2fs
	
TARGETS += e2fsprogs-target
CLEAN_TARGETS += e2fsprogs-clean
DISTCLEAN_TARGTETS += e2fsprogs-distclean
