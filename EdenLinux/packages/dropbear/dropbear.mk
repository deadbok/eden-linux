DROPBEAR_VERSION := 0.52
DROPBEAR_FILE := dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_URL := http://matt.ucc.asn.au/dropbear/releases/$(DROPBEAR_FILE)

$(DLDIR)/$(DROPBEAR_FILE):
	$(WGET) $(DROPBEAR_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/configure.in: $(DLDIR)/$(DROPBEAR_FILE)
	tar $(VERBOSE_FLAG) -xjf $(DLDIR)/$(DROPBEAR_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/configure.in

$(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/Makefile: $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/configure.in
	(cd $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION); \
		$(TOOLCHAIN) ./configure --prefix=/usr --target=$(EDEN_ARCH_TARGET)\
  		--host=$(EDEN_ARCH_TARGET) --with-cc="$(EDEN_ARCH_TARGET)-gcc -Os" \
  		--with-linker=$(EDEN_ARCH_TARGET)-ld --with-zlib=$(ROOTFS)/usr/lib);
	
$(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/dropbear: $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION) MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

$(ROOTFS)/usr/bin/dropbear: $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION)/dropbear
	$(MAKE) -C $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION) MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" install DESTDIR=$(ROOTFS)
	ln -svf ../../usr/bin/dropbearmulti $(ROOTFS)/usr/sbin/dropbear
	ln -svf ../../usr/bin/dropbearmulti $(ROOTFS)/usr/bin/dbclient
	ln -svf ../../usr/bin/dropbearmulti $(ROOTFS)/usr/bin/dropbearkey
	ln -svf ../../usr/bin/dropbearmulti $(ROOTFS)/usr/bin/dropbearconvert
	ln -svf ../../usr/bin/dropbearmulti $(ROOTFS)/usr/bin/scp
	
		
dropbear-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION) distclean

dropbear-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/dropbear-$(DROPBEAR_VERSION) distclean
	
dropbear-target: zlib-target $(ROOTFS)/usr/bin/dropbear
	
TARGETS += dropbear-target
CLEAN_TARGETS += dropbear-clean
DISTCLEAN_TARGTETS += dropbear-distclean
