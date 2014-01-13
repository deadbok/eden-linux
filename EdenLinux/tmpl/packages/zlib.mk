#mtl
${local_namespace("packages.zlib")}

#${package("$(PACKAGES_BUILD_DIR)/zlib-$(PACKAGES_ZLIB_VERSION)", "", "1.2.5", "zlib-$(PACKAGES_ZLIB_VERSION).tar.gz", "http://www.zlib.net/$(PACKAGES_ZLIB_FILE)")}
#${Package("$(PACKAGES_BUILD_DIR)/zlib-$(PACKAGES_ZLIB_VERSION)", "", "1.2.5", "http://www.zlib.net/linux-$(PACKAGES_KERNEL_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/lib/libz.a")}

${local()}INSTALL_PARAM = prefix=$(ROOTFS_DIR)/usr -j1
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --shared
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = -j1
${local()}BUILD_ENV = $(PACKAGES_ENV)  

${py zlib = AutoconfPackage('$(PACKAGES_BUILD_DIR)/zlib-$(PACKAGES_ZLIB_VERSION)', '', '1.2.8', "http://www.zlib.net/zlib-$(PACKAGES_ZLIB_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/lib/libz.a")}
${zlib}
#${download()}

#${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_ZLIB_SRC_DIR)/configure")}

#${DownloadRule("$(DOWNLOAD_DIR)", "$(PACKAGES_ZLIB_URL)")}

#${UnpackRule("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_ZLIB_SRC_DIR)/configure")}

#${autoconf('$(TOOLCHAIN_ENV)', '--prefix=/usr --shared', "")}

#${make("$(TOOLCHAIN_ENV)", '-j1', "all", "$(PACKAGES_ZLIB_BUILD_DIR)/libz.a", "$(PACKAGES_ZLIB_CONFIG)")}
#${MakeRule("$(TOOLCHAIN_ENV)", "-j1", "$(PACKAGES_BASECONF_BUILD_DIR)", "all", "$(PACKAGES_ZLIB_BUILD_DIR)/libz.a", var_name("build"), "$(PACKAGES_ZLIB_CONFIG)")}

#${make("$(TOOLCHAIN_ENV)", 'prefix=$(ROOTFS_DIR)/usr -j1', "install", "$(ROOTFS_DIR)/usr/lib/libz.a", "$(PACKAGES_ZLIB_ALL)")}
#${MakeRule("$(TOOLCHAIN_ENV)", "prefix=$(ROOTFS_DIR)/usr -j1", "$(PACKAGES_BASECONF_BUILD_DIR)", "install", "$(ROOTFS_DIR)/usr/lib/libz.a", var_name("install"), "$(PACKAGES_ZLIB_BUILD)")}



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


.NOTPARALLEL: