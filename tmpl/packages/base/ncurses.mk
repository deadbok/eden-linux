#mtl

#Ncurses will not generate and install the pkg config files if the target
#directory does not exist while configuring (Found this info in a NixOS patch) 
${local_namespace("packages.base.ncurses")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) \
						 --host=$(ARCH_TARGET) \
						 --with-cc="$(ARCH_TARGET)-gcc -Os" \
						 --with-linker=$(ARCH_TARGET)-ld --with-shared \
						 --without-debug --without-ada --with-build-cc=gcc \
						 --enable-overwrite --without-cxx-binding \
						 --enable-pc-files --program-prefix= \
						 --mandir=/usr/share/man --enable-widec \
						 --with-pkg-config=$(HOST_ROOT_DIR)/bin
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM =
# MULTI=1 PROGRAMS="ncurses dbclient ncurseskey ncursesconvert scp"
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py ncurses = AutoconfPackage('$(PACKAGES_BUILD_DIR)/ncurses-$(PACKAGES_BASE_NCURSES_VERSION)', '', '5.9', "http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$(PACKAGES_BASE_NCURSES_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/pkgconfig/ncursesw.pc", "$(PACKAGES_ENV)")}

${ncurses.vars()}

${ncurses.rules['download']}

${ncurses.rules['unpack']}
	
${ncurses.rules['patchall']}

${ncurses.rules['config']}

${ncurses.rules['build']}

#Ncurses installs stuff in wierd places
${ncurses.rules['install']}
	$(MV) $(ROOTFS_DIR)/$(ROOTFS_DIR)/usr/lib/pkgconfig/* $(ROOTFS_DIR)/usr/lib/pkgconfig/
#TODO: Anything else than wipe /home/*
	#-$(RM) -Rf $(ROOTFS_DIR)/home/*

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_NCURSES_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: