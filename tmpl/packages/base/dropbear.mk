#mtl
${local_namespace("packages.base.dropbear")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR) MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --with-cc="$(ARCH_TARGET)-gcc -Os" --with-linker=$(ARCH_TARGET)-ld --with-zlib=$(ROOTFS_DIR)/usr/lib
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = MULTI=1 PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"
${local()}BUILD_ENV = $(PACKAGES_ENV)

${local()}DEPENDENCIES = $(PACKAGES_BASE_ZLIB_INSTALL) 

SERVICES += dropbear

${py dropbear = AutoconfPackage('$(PACKAGES_BUILD_DIR)/dropbear-$(PACKAGES_BASE_DROPBEAR_VERSION)', '', '0.52', "http://matt.ucc.asn.au/dropbear/releases/dropbear-$(PACKAGES_BASE_DROPBEAR_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/dropbear")}

${dropbear.vars()}

${dropbear.rules['download']}

${dropbear.rules['unpack']}

${dropbear.rules['patchall']}

${dropbear.rules['config']}

${dropbear.rules['build']}

${dropbear.rules['install']}
	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dropbear
	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dbclient
	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dropbearkey
	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/dropbearconvert
	$(LN) -s dropbearmulti $(ROOTFS_DIR)/usr/bin/scp
	$(CP) -R $(ROOT)/${namespace.current.replace(".", "/")}/etc $(ROOTFS_DIR)/

#Add to targets	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_DROPBEAR_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: