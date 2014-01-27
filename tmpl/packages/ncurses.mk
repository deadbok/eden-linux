#mtl
${local_namespace("packages.ncurses")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-shared --without-debug --without-ada --with-build-cc=gcc --enable-overwrite --without-cxx-binding --program-prefix= --mandir=$(ROOTFS_DIR)/usr/share/man
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = MULTI=1 PROGRAMS="ncurses dbclient ncurseskey ncursesconvert scp"
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py ncurses = AutoconfPackage('$(PACKAGES_BUILD_DIR)/ncurses-$(PACKAGES_NCURSES_VERSION)', '', '5.7', "http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$(PACKAGES_NCURSES_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/libncurses.a", "$(PACKAGES_ENV)")}
${ncurses}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_NCURSES_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: