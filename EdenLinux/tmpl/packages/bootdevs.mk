#mtl
${local_namespace("packages.bootdevs")}

${Package("$(ROOT)/packages/bootdevs", "", "1.0", "", "$(ROOTFS_DIR)/.devs")}


${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BOOTDEVS_BUILD_DIR)", "install", "$(ROOTFS_DIR)/.dev", "", var_name("install"))} 


#${package("$(ROOT)/packages/bootdevs", "", "1.0", "", "")}
#
#${make("", "DESTDIR=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/.devs", "")}
#	$(TOUCH) $(PACKAGES_BOOTDEVS_INSTALL)

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

.NOTPARALLEL: