#mtl
${local_namespace("packages.syslinux")}

${package("$(PACKAGES_BUILD_DIR)/syslinux-$(PACKAGES_SYSLINUX_VERSION)", "", "4.02", "syslinux-$(PACKAGES_SYSLINUX_VERSION).tar.bz2", "http://linux-kernel.uio.no/pub/linux/utils/boot/syslinux/4.xx/$(PACKAGES_SYSLINUX_FILE)")}

${local}VERSION = 4.02
${local}EXTLINUX_CONFIG = $(ROOT)/packages/syslinux/extlinux.conf
${local}ISOLINUX_CONFIG = $(ROOT)/packages/syslinux/isolinux.cfg

$(ROOTFS_DIR)/boot/extlinux.conf: $(PACKAGES_SYSLINUX_EXTLINUX_CONFIG)
	$(CP) $(PACKAGES_SYSLINUX_EXTLINUX_CONFIG) $(ROOTFS_DIR)/boot/extlinux.conf

#packages:
#	syslinux:
#		version = 4.02
#		group = basesystem
#		extlinux_config = ${root}/${file_dir.packages}/syslinux/extlinux.conf
#		isolinux_config = ${root}/${file_dir.packages}/syslinux/isolinux.cfg
#	
#		copy(${root}/${rootfs_dir}/boot/extlinux.conf, source = "${extlinux_config}", ${install.fsh.packages})
#		clean()
#		{
#			clean_syslinux_packages:
#				$rm ${root}/${rootfs_dir}/boot/extlinux.conf
#		}
#		distclean()
#		{
#			distclean_syslinux_packages:
#				$rm ${root}/${rootfs_dir}/boot/extlinux.conf
#		}
#	:syslinux
#:packages
#= $(ROOT)/${put(namespace.current.replace(".", "/"))}/syslinux/extlinux.conf
#= $(ROOT)/${put(namespace.current.replace(".", "/"))}/syslinux/isolinux.cfg