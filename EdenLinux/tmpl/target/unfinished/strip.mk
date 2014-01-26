##mtl
${local_namespace("target.strip")}

${Package("", "", "1.0", "", "$(TEMP_DIR)/.target-stripped")}

${Rule("$(TEMP_DIR)/.target-stripped", dependencies = "$(PACKAGES_INSTALL) $(STRIPPED_ROOTFS_DIR)", rule_var_name= var_name("install"))}
	-($(TOOLCHAIN_ROOT_DIR)/bin/$(TOOLCHAIN_STRIP) $(VERBOSE_FLAG) -x --strip-debug -R .note -R .comment $(TARGET_ROOTFS_DIR)/{usr/,}{sbin/*,bin/*})
	(find $(TARGET_ROOTFS_DIR)/lib/ \( -name '*ko' -o -name '*so' -o -name '*.a' -o -name '*.gox' \) -exec $(TOOLCHAIN_ROOT_DIR)/bin/$(TOOLCHAIN_STRIP) $(VERBOSE_FLAG) -x --strip-debug -R .note -R .comment {} \;)
	(find $(TARGET_ROOTFS_DIR)/usr/lib/ \( -name '*so' -o -name '*.a' -o -name '*.gox' \) -exec $(TOOLCHAIN_ROOT_DIR)/bin/$(TOOLCHAIN_STRIP) $(VERBOSE_FLAG) -x --strip-debug -R .note -R .comment {} \;)	
	$(TOUCH) $@
