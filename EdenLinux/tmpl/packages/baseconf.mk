#mtl
${local_namespace("packages.baseconf")}

${Package("$(ROOT)/packages/baseconf", "", "1.0", "", "$(ROOTFS_DIR)/etc/hosts")}

${var_name("etc_files")} = $(call rwildcard,$(PACKAGES_BASECONF_BUILD_DIR)/etc,*)

${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BASECONF_BUILD_DIR)", "install", "$(ROOTFS_DIR)/etc/hosts", var_name("etc_files", True) + " $(PACKAGES_BASECONF_BUILD_DIR)/Makefile", var_name("install"))} 

.NOTPARALLEL: