#mtl
${local_namespace("packages.baseconf")}

${package("$(ROOT)/packages/baseconf", "", "1.0", "", "")}

${make("", "DESTDIR=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/etc/profile", "")}
	$(TOUCH) $(PACKAGES_BASECONF_INSTALL)

#	
#packages:
#	baseconf:
#		group = basesystem
#	
#		install(${root}/${rootfs_dir}/etc/profile, make_opts="DESTDIR=${root}/${rootfs_dir} ROOT_DEVICE=${root_device} SWAP_DEVICE=${swap_device}")
#		{
#			${target}:
#				$make -C ${package_file_dir} install ${make_opts}
#		}
#		clean()
#		distclean()
#	:baseconf
#:packages
