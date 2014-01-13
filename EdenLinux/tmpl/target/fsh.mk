#mtl
${local_namespace("target.fsh")}

${Package("$(ROOT)/target/fsh", "", "1.0", "", "$(TEMP_DIR)/.fsh")}

${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(TARGET_FSH_BUILD_DIR)", "install", "$(TEMP_DIR)/.fsh", "", var_name("install"))}
	$(TOUCH) $(TEMP_DIR)/.fsh

	
