#mtl
${local_namespace("target.strip")}

${Package("", "", "1.0", "", "$(TEMP_DIR)/.target-stripped")}

${Rule('strip-all' '')}
	-($(TOOLCHAIN_ROOT_DIR)/bin/$(TOOLCHAIN_STRIP) $(VERBOSE_FLAG) -x --strip-debug -R .note -R .comment $(IMAGE_ROOTFS_DIR)/{usr/,}{sbin/*,bin/*})
	(find $(IMAGE_ROOTFS_DIR)/lib/ \( -name '*ko' -o -name '*so' -o -name '*.a' -o -name '*.gox' \) -exec $(TOOLCHAIN_ROOT_DIR)/bin/$(TOOLCHAIN_STRIP) $(VERBOSE_FLAG) -x --strip-debug -R .note -R .comment {} \;)
	(find $(IMAGE_ROOTFS_DIR)/usr/lib/ \( -name '*so' -o -name '*.a' -o -name '*.gox' \) -exec $(TOOLCHAIN_ROOT_DIR)/bin/$(TOOLCHAIN_STRIP) $(VERBOSE_FLAG) -x --strip-debug -R .note -R .comment {} \;)	
	$(TOUCH) $@
