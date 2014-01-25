#mtl
${local_namespace("packages.dropbear")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR) MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-zlib=$(ROOTFS_DIR)/usr/lib
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_ZLIB_INSTALL) 

${py dropbear = AutoconfPackage('$(PACKAGES_BUILD_DIR)/dropbear-$(PACKAGES_DROPBEAR_VERSION)', '', '0.52', "http://matt.ucc.asn.au/dropbear/releases/dropbear-$(PACKAGES_DROPBEAR_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/dropbear")}
${py dropbear.rules['install'].recipe.append("$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dropbear\n")}
${py dropbear.rules['install'].recipe.append("$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dbclient\n")}

${dropbear}

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_DROPBEAR_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_DROPBEAR_INSTALL)
PACKAGES_NAME_TARGETS += dropbear

.NOTPARALLEL: