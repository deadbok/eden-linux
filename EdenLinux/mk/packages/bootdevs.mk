#mtl
${local_namespace("packages.bootdevs")}

${package("$(ROOT)/packages/bootdevs", "", "1.0", "", "")}

${make("", "DESTDIR=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/.devs", "")}
	$(TOUCH) $(ROOTFS_DIR) / .devs

#packages:
#	bootdevs:
#		group = basesystem
#	
#		install(make_opts="DESTDIR=${root}/${rootfs_dir}")
#		{
#			${target}:
#				$make -C ${package_file_dir} install ${make_opts}
#		}
#		clean()
#		distclean()
#	:bootdevss
#:packages
