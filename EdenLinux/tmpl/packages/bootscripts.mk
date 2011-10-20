#mtl
${local_namespace("packages.bootscripts")}

#${package("$(ROOT)/packages/bootscripts", "", "1.0", "", "")}
${py bootscripts = Package("$(ROOT)/packages/bootscripts", "", "1.0", "", "$(ROOTFS_DIR)/sbin/rc-update.py")}
${bootscripts}

${py install = MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BOOTSCRIPTS_BUILD_DIR)", "install", "$(ROOTFS_DIR)/sbin/rc-update.py", "", var_name("install"))} 
${install}

#${make("", "DESTDIR=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/sbin/rc-update.py", "")}
#	$(TOUCH) $(PACKAGES_BOOTSCRIPTS_INSTALL)

#packages:
#	bootscripts:
#		group = basesystem
#	
#		install(${root}/${rootfs_dir}/sbin/rc-update.py, make_opts="DESTDIR=${root}/${rootfs_dir}")
#		{
#			${target}:
#				$make -C ${package_file_dir} install ${make_opts}
#		}
#		clean()
#		distclean()
#	:bootscripts
#:packages

.NOTPARALLEL: