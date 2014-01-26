#mtl
${local_namespace("target.services")}
	
${Package("", "", "1.0", "", "$(ROOTFS_DIR)/etc/rc.d/.services")}

STRIPPED_BOOT_SERVICES := $(subst ",,$(BOOT_SERVICES))
STRIPPED_SERVICES := $(subst ",,$(SERVICES))

${Rule("$(TEMP_DIR)/.services", "$(PACKAGES_BOOTSCRIPTS_HOST_BUILD)", "", var_name("install"))}
	@echo "Adding services to boot runlevel: $(STRIPPED_BOOT_SERVICES)"
	$(foreach SERVICE,$(strip $(STRIPPED_BOOT_SERVICES)), $(LN) -sf ../../init.d/$(SERVICE) $(ROOTFS_DIR)/etc/runlevels/boot/$(SERVICE);)
	@echo "Adding services to default runlevel: $(STRIPPED_SERVICES)"
	$(foreach SERVICE,$(strip $(STRIPPED_SERVICES)), $(LN) -sf ../../init.d/$(SERVICE) $(ROOTFS_DIR)/etc/runlevels/default/$(SERVICE);)
	-$(CHMOD) 754 754 $(ROOTFS_DIR)/etc/init.d/*
