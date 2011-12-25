#mtl
${local_namespace("target.zip-man")}
	
${Package("", "", "1.0", "", "$(TEMP_DIR)/.zip-man")}

${var_name("man_files")} = $(call rwildcard,$(TARGET_ROOTFS_DIR)/usr/man,*)

${Rule("$(TEMP_DIR)/.zip-man", dependencies = "$(PACKAGES_INSTALL) $(TARGET_ZIP-MAN_MAN_FILES)", rule_var_name= var_name("install"))}
	$(ROOT)/target/zip-man/cman.sh $(VERBOSE_FLAG) $(TARGET_ROOTFS_DIR)/usr/man $(TARGET_ROOTFS_DIR)/usr/share/man
	$(TOUCH) $@
	
