#mtl
${local_namespace("packages.baseconf")}

BOOT_SERVICES += syslogd

${Package("$(ROOT)/packages/baseconf", "", "1.0", "", "$(ROOTFS_DIR)/etc/hosts")}

#Variable with the names of all files in etc
${var_name("etc_files")} = $(call rwildcard,$(PACKAGES_BASECONF_BUILD_DIR)/etc,*)

${MakeRule("", "DESTDIR=$(ROOTFS_DIR) MODULES=$(KERNEL_MODULES) ROOT_DEVICE=$(ROOT_DEVICE)", "$(PACKAGES_BASECONF_BUILD_DIR)", "install", "$(ROOTFS_DIR)/etc/hosts", var_name("etc_files", True) + " $(PACKAGES_BASECONF_BUILD_DIR)/Makefile", var_name("install"))} 

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASECONF_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}
.NOTPARALLEL: