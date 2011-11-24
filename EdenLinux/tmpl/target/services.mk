#mtl
${local_namespace("target.services")}
	
${Package("", "", "1.0", "", "$(ROOTFS_DIR)/etc/rc.d/.services")}

${Rule("$(ROOTFS_DIR)/etc/rc.d/.services", "$(PACKAGES_BOOTSCRIPTS_HOST_BUILD)", "", var_name("install"))}
	$(foreach SERVICE, $(SERVICES), $(TOOLCHAIN_ROOT_DIR)/sbin/rc-update -dir="$(ROOTFS_DIR)/etc" -add $(SERVICE);)
	
