#mtl
${local_namespace("packages.ncurses")}

#${package("$(PACKAGES_BUILD_DIR)/ncurses-$(PACKAGES_NCURSES_VERSION)", "", "5.7", "ncurses-$(PACKAGES_NCURSES_VERSION).tar.gz", "http://ftp.gnu.org/pub/gnu/ncurses/$(PACKAGES_NCURSES_FILE)")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-shared --without-debug --without-ada --with-build-cc=gcc --enable-overwrite --without-cxx-binding --program-prefix=
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = MULTI=1 PROGRAMS="ncurses dbclient ncurseskey ncursesconvert scp"
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py ncurses = AutoconfPackage('$(PACKAGES_BUILD_DIR)/ncurses-$(PACKAGES_NCURSES_VERSION)', '', '5.7', "http://ftp.gnu.org/pub/gnu/ncurses/ncurses-$(PACKAGES_NCURSES_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/libncurses.a", "$(PACKAGES_ENV)")}
${ncurses}

#${download()}

#${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_NCURSES_SRC_DIR)/configure")}

#${autoconf('$(TOOLCHAIN_ENV)', '--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-shared --without-debug --without-ada --with-build-cc=gcc --enable-overwrite --without-cxx-binding --program-prefix=', "")}

#${make("$(TOOLCHAIN_ENV)", 'MULTI=1 PROGRAMS="ncurses dbclient ncurseskey ncursesconvert scp"', "all", "$(PACKAGES_NCURSES_BUILD_DIR)/lib/libncurses.a", "$(PACKAGES_NCURSES_CONFIG)")}

#${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/usr/lib/libncurses.a", "$(PACKAGES_NCURSES_ALL)")}


#
#packages:
#	ncurses:
#		version = 5.7
#		dir = ncurses-${version}
#		group = basesystem
#		url = http://ftp.gnu.org/pub/gnu/ncurses/ncurses-${version}.tar.gz
#	
#
#		download()
#		unpack(${build_dir.packages}/${dir}/configure)
#		config(config_opts = "--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-shared --without-debug --without-ada --with-build-cc=gcc --enable-overwrite --without-cxx-binding --program-prefix=", ${build_dir.packages}/${dir}/Makefile, ${unpack})
#		build(${build_dir.packages}/${dir}/lib/libncurses.a, make_opts = "MULTI=1 PROGRAMS="ncurses dbclient ncurseskey ncursesconvert scp"", ${build_dir.packages}/${dir}/Makefile)
#		install(make_opts = "DESTDIR=${root}/${rootfs_dir}", ${rootfs_dir}/usr/lib/libncurses.a, ${build_dir.packages}/${dir}/lib/libncurses.a)
#		clean()
#		distclean()
#	:ncurses
#:packages

.NOTPARALLEL: