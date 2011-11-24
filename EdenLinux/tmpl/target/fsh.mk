#mtl
${local_namespace("target.fsh")}

#${package("$(ROOT)/target/fsh", "", "1.0", "", "")}

#${make("", "DESTDIR=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/.fsh", "")}
#	$(TOUCH) $(ROOTFS_DIR)/.fsh
	
${Package("$(ROOT)/target/fsh", "", "1.0", "", "$(ROOTFS_DIR)/.fsh")}

${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(TARGET_FSH_BUILD_DIR)", "install", "$(ROOTFS_DIR)/.fsh", "", var_name("install"))}
	$(TOUCH) $(ROOTFS_DIR)/.fsh

	
