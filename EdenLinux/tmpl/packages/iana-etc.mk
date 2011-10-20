#mtl
${local_namespace("packages.iana-etc")}

#${package("$(PACKAGES_BUILD_DIR)/iana-etc-$(PACKAGES_IANA-ETC_VERSION)", "", "2.30", "iana-etc-$(PACKAGES_IANA-ETC_VERSION).tar.bz2", "http://sethwklein.net/$(PACKAGES_IANA-ETC_FILE)")}

#${download()}

#${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_IANA-ETC_SRC_DIR)/Makefile")}

#${make("$(TOOLCHAIN_ENV)", '', "all", "$(PACKAGES_IANA-ETC_BUILD_DIR)/services", "$(PACKAGES_IANA-ETC_SRC_DIR)/Makefile")}

#${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/etc/services", "$(PACKAGES_IANA-ETC_ALL)")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = 
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py iana_etc = AutoconfPackage('$(PACKAGES_BUILD_DIR)/iana-etc-$(PACKAGES_IANA-ETC_VERSION)', '', '2.30', "http://sethwklein.net/iana-etc-$(PACKAGES_IANA-ETC_VERSION).tar.bz2", "$(ROOTFS_DIR)/etc/services")}

${iana_etc.vars()}

${iana_etc.rules['download']}

${py iana_etc.rules['unpack'].target = '$(PACKAGES_IANA-ETC_SRC_DIR)/Makefile' }
${iana_etc.rules['unpack']}

${py iana_etc.rules['build'].dependencies = ' $(PACKAGES_IANA-ETC_UNPACK)' }
${iana_etc.rules['build']}

${iana_etc.rules['install']}
	
#
#
#packages:
#	iana-etc:
#		version = 2.30
#		dir = iana-etc-${version}
#		group = basesystem
#		url = http://ftp.osuosl.org/pub/lfs/hlfs-packages/unstable/iana-etc-${version}.tar.bz2
#	
#		download()
#		unpack(${build_dir.packages}/${dir}/configure)
#		build(${build_dir.packages}/${dir}/services, ${unpack})
#		install(make_opts = "DESTDIR=${root}/${rootfs_dir}", ${root}/${rootfs_dir}/etc/services, ${build_dir.packages}/${dir}/services)
#		clean()
#		distclean()
#	:iana-etc
#:packages

.NOTPARALLEL:
