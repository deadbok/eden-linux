#mtl
${local_namespace("target.fsh")}

${package("$(ROOT)/target/fsh", "", "1.0", "", "")}

${make("", "DESTDIR=$(ROOTFS_DIR)", "install", "$(ROOTFS_DIR)/.fsh", "")}
	$(TOUCH) $(ROOTFS_DIR)/.fsh