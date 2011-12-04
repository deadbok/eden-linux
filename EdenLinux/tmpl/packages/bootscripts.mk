#mtl
${local_namespace("packages.bootscripts")}

SERVICES += syslog clock mountroot localmount network modules
${py bootscripts = Package("$(ROOT)/packages/bootscripts", "$(PACKAGES_BUILD_DIR)/bootscripts", "1.0", "", "$(ROOTFS_DIR)/sbin/rc-update")}
${bootscripts}


${Rule('$(PACKAGES_BOOTSCRIPTS_BUILD_DIR)/Makefile', rule_var_name=var_name("copy_src"))}
	$(CP) -au $(PACKAGES_BOOTSCRIPTS_SRC_DIR) $(PACKAGES_BUILD_DIR)

TOOLCHAIN_BOOTSCRIPTS_BUILD_DIR := $(TOOLCHAIN_BUILD_DIR)/bootscripts


${Rule('$(TOOLCHAIN_BOOTSCRIPTS_BUILD_DIR)/Makefile', rule_var_name= var_name("host-copy_src"))}
	$(CP) -ua $(PACKAGES_BOOTSCRIPTS_SRC_DIR) $(TOOLCHAIN_BUILD_DIR)

.PHONY: $(${var_name("copy_src")})
.PHONY: $(${var_name("host-copy_src")})

${MakeRule("$(PACKAGES_ENV)", "CROSS_COMPILE=$(ARCH_TARGET)-", "$(PACKAGES_BOOTSCRIPTS_BUILD_DIR)", "all", "$(PACKAGES_BOOTSCRIPTS_BUILD_DIR)/src/rc-update", "$(PACKAGES_BOOTSCRIPTS_COPY_SRC)", var_name("build"))}

${MakeRule("", "DESTDIR=$(TOOLCHAIN_ROOT_DIR) DEBUG=1", "$(TOOLCHAIN_BOOTSCRIPTS_BUILD_DIR)", "$(TOOLCHAIN_ROOT_DIR)/sbin/rc-update", "$(TOOLCHAIN_ROOT_DIR)/sbin/rc-update", "$(PACKAGES_BOOTSCRIPTS_HOST-COPY_SRC)", var_name("host-build"))}

${py install = MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BOOTSCRIPTS_BUILD_DIR)", "install", "$(ROOTFS_DIR)/sbin/rc-update.py", "", var_name("install"))} 
${install}


HOST_RC-UPDATE = $(TOOLCHAIN_ROOT_DIR)/sbin/rc-update
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