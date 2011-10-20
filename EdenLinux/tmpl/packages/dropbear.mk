#mtl
${local_namespace("packages.dropbear")}

#${package("$(PACKAGES_BUILD_DIR)/dropbear-$(PACKAGES_DROPBEAR_VERSION)", "", "0.52", "dropbear-$(PACKAGES_DROPBEAR_VERSION).tar.gz", "http://matt.ucc.asn.au/dropbear/releases/$(PACKAGES_DROPBEAR_FILE)")}

#${download()}

#${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_DROPBEAR_SRC_DIR)/configure")}

#${autoconf('$(PACKAGES_ENV)', '--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-zlib=$(ROOTFS_DIR)/usr/lib', "")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR) MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-zlib=$(ROOTFS_DIR)/usr/lib
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py dropbear = AutoconfPackage('$(PACKAGES_BUILD_DIR)/dropbear-$(PACKAGES_DROPBEAR_VERSION)', '', '0.52', "http://matt.ucc.asn.au/dropbear/releases/dropbear-$(PACKAGES_DROPBEAR_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/dropbear")}
${py dropbear.rules['install'].recipe.append("$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dropbear\n")}
${py dropbear.rules['install'].recipe.append("$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dbclient\n")}
${dropbear}

#${make("$(PACKAGES_ENV)", 'MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"', "all", "$(PACKAGES_DROPBEAR_BUILD_DIR)/dropbear", "$(PACKAGES_DROPBEAR_CONFIG)")}

#${make("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR) MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"', "install", "$(ROOTFS_DIR)/usr/bin/dropbear", "$(PACKAGES_DROPBEAR_ALL)")}
#	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dropbear
#	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dbclient

#packages:
#	dropbear:
#		version = 0.52
#		dir = dropbear-${version}
#		group = basesystem
#		url = http://matt.ucc.asn.au/dropbear/releases/dropbear-${version}.tar.gz
#	
#
#		download()
#		unpack(${build_dir.packages}/${dir}/configure)
#		patch(${build_dir.packages}/${dir}/.patched, ${unpack})
#		config(config_opts = "--prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-zlib=${root}/${rootfs_dir}/usr/lib", ${build_dir.packages}/${dir}/Makefile, ${patch} ${install.zlib.packages})
#		build(${build_dir.packages}/${dir}/dropbear, make_opts =" MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"", ${build_dir.packages}/${dir}/Makefile)
#		install(install-dropbear.mk, make_opts = "DESTDIR=${root}/${rootfs_dir} MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"", ${rootfs_dir}/usr/bin/dropbear, ${build_dir.packages}/${dir}/dropbear)
#		clean()
#		distclean()
#	:dropbear
#:packages

.NOTPARALLEL: