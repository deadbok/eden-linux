#mtl
${local_namespace("packages.zlib")}

${package("$(PACKAGES_BUILD_DIR)/zlib-$(PACKAGES_ZLIB_VERSION)", "", "1.2.5", "zlib-$(PACKAGES_ZLIB_VERSION).tar.gz", "http://www.zlib.net/$(PACKAGES_ZLIB_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_ZLIB_SRC_DIR)/configure")}

${autoconf('$(TOOLCHAIN_ENV)', '--prefix=/usr --shared', "")}

${make("$(TOOLCHAIN_ENV)", '-j1', "all", "$(PACKAGES_ZLIB_BUILD_DIR)/libz.a", "$(PACKAGES_ZLIB_CONFIG)")}

${make("$(TOOLCHAIN_ENV)", 'prefix=$(ROOTFS_DIR)/usr -j1', "install", "$(ROOTFS_DIR)/usr/lib/libz.a", "$(PACKAGES_ZLIB_ALL)")}




#packages:
#	zlib:
#		version = 1.2.5
#		dir = zlib-${version}
#		group = basesystem
#		url = http://www.zlib.net/zlib-${version}.tar.gz
#	
#
#		download()
#		unpack(${build_dir.packages}/${dir}/configure)
#		config(config_opts = "--prefix=/usr --shared", ${build_dir.packages}/${dir}/Makefile, ${unpack})
#		build(make_opts = "-j1", ${build_dir.packages}/${dir}/libz.a, ${config} ${install.toolchain})
#		install(make_opts = "prefix=${root}/${rootfs_dir}/usr -j1", ${rootfs_dir}/usr/lib/libz.a, ${build_dir.packages}/${dir}/libz.a)
#		clean()
#		distclean()
#	:zlib
#:packages
