#mtl
${local_namespace("target.headers")}

${Package("", "", "1.0", "", "$(TEMP_DIR)/.headers-removed")}

${Rule("$(TEMP_DIR)/.headers-removed", dependencies = "$(PACKAGES_INSTALL) $(STRIPPED_ROOTFS_DIR)", rule_var_name= var_name("remove"))}
	-($(RM) -fR $(TARGET_ROOTFS_DIR)/usr/include)
	$(TOUCH) $@
