#mtl
${local_namespace("target.zip-man")}
	
${Package("", "", "1.0", "", "$(TEMP_DIR)/.zip-man")}

${Rule("zip-man", "")}
	$(ROOT)/target/zip-man/cman.sh $(VERBOSE_FLAG) $(IMAGE_ROOTFS_DIR)/usr/share/man
	$(TOUCH) $@
	
