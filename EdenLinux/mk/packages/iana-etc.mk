#mtl
${local_namespace("packages.iana-etc")}

${package("$(PACKAGES_BUILD_DIR)/iana-etc-$(PACKAGES_IANA-ETC_VERSION)", "", "2.30", "iana-etc-$(PACKAGES_IANA-ETC_VERSION).tar.bz1", "http://ftp.osuosl.org/pub/lfs/hlfs-packages/unstable/$(PACKAGES_IANA-ETC_FILE)")}

${download}

${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_IANA-ETC_SRC_DIR)/Makefile")}

${make("$(TOOLCHAIN_ENV)", '', "all", "$(PACKAGES_IANA-ETC_BUILD_DIR)/services", "$(PACKAGES_IANA-ETC_SRC_DIR)/Makefile")}

${make("$(TOOLCHAIN_ENV)", 'DESTDIR=$(ROOTFS_DIR)', "install", "$(ROOTFS_DIR)/etc/services", "$(PACKAGES_IANA-ETC_ALL)")}


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
