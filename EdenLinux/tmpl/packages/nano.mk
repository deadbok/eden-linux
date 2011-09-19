#mtl
${local_namespace("packages.nano")}

${package("$(PACKAGES_BUILD_DIR)/nano-$(PACKAGES_NANO_VERSION)", "", "2.2.5", "nano-$(PACKAGES_NANO_VERSION).tar.gz", "http://www.nano-editor.org/dist/v2.2/$(PACKAGES_NANO_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_NANO_SRC_DIR)/configure")}

${autoconf('$(TOOLCHAIN_ENV)', '--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --enable-tiny --program-prefix=', "")}

${make("$(TOOLCHAIN_ENV)", '', "all", "$(PACKAGES_NANO_BUILD_DIR)/src/nano", "$(PACKAGES_NANO_CONFIG)")}

${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/usr/bin/nano", "$(PACKAGES_NANO_ALL)")}

#
#packages:
#	nano:
#		version = 2.2.5
#		dir = nano-${version}
#		group = basesystem
#		url = http://www.nano-editor.org/dist/v2.2/nano-${version}.tar.gz
#	
#
#		download()
#		unpack(${build_dir.packages}/${dir}/configure)
#		patch(${build_dir.packages}/${dir}/.patched, ${unpack})
#		config(config_opts = "--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --enable-tiny --program-prefix=", ${build_dir.packages}/${dir}/Makefile, ${unpack} ${install.nano.packages})
#		build(${build_dir.packages}/${dir}/src/nano, ${build_dir.packages}/${dir}/Makefile)
#		install(make_opts = "DESTDIR=${root}/${rootfs_dir}", ${root}/${rootfs_dir}/usr/bin/nano, ${build_dir.packages}/${dir}/src/nano)
#		clean()
#		distclean()
#	:nano
#:packages
