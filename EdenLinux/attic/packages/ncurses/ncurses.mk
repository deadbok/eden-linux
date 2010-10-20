NCURSES_VERSION := 5.7
NCURSES_FILE := ncurses-$(NCURSES_VERSION).tar.gz
NCURSES_URL := http://ftp.gnu.org/pub/gnu/ncurses/$(NCURSES_FILE)

$(DLDIR)/$(NCURSES_FILE):
	$(WGET) $(NCURSES_URL) -P $(DLDIR)

$(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/configure.in: $(DLDIR)/$(NCURSES_FILE)
	tar $(VERBOSE_FLAG) -xzf $(DLDIR)/$(NCURSES_FILE) -C $(ARCH_BUILD_DIR)
	touch $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/configure.in

$(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/Makefile: $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/configure.in
	(cd $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION); \
		$(TOOLCHAIN) ./configure --prefix=/usr --target=$(EDEN_ARCH_TARGET)\
  		--host=$(EDEN_ARCH_TARGET) --with-cc="$(EDEN_ARCH_TARGET)-gcc -Os" \
  		--with-linker=$(EDEN_ARCH_TARGET)-ld --with-shared --without-debug \
  		--without-ada --with-build-cc=gcc --enable-overwrite --without-cxx-binding \
  		--program-prefix=);
	
$(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/lib/libncurses.a: $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/Makefile
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION) MULTI=1 PROGRAMS="ncurses dbclient ncurseskey ncursesconvert scp"

$(ROOTFS)/usr/lib/libncurses.a: $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION)/lib/libncurses.a
	$(TOOLCHAIN) $(MAKE) -C $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION) DESTDIR=$(ROOTFS) install
		
ncurses-clean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION) distclean

ncurses-distclean:
	-$(MAKE) -C $(ARCH_BUILD_DIR)/ncurses-$(NCURSES_VERSION) distclean
	
ncurses-target: busybox-target $(ROOTFS)/usr/lib/libncurses.a
	
TARGETS += ncurses-target
CLEAN_TARGETS += ncurses-clean
DISTCLEAN_TARGTETS += ncurses-distclean
