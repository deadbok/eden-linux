#mtl
${local_namespace("packages.base.baseconf")}

BOOT_SERVICES += syslogd

${Package("$(PACKAGES_BASE_FILE_DIR)/baseconf", "", "1.0", "", "$(ROOTFS_DIR)/etc/hosts")}

#Variable with the names of all files in etc
${var_name("etc_files")} = $(call rwildcard,$(PACKAGES_BASE_BASECONF_BUILD_DIR)/etc,*)

${MakeRule("", "DESTDIR=$(ROOTFS_DIR) MODULES=$(KERNEL_MODULES) ROOT_DEVICE=$(ROOT_DEVICE)", "$(PACKAGES_BASE_BASECONF_BUILD_DIR)", "install", "$(ROOTFS_DIR)/etc/hosts", var_name("etc_files", True) + " $(PACKAGES_BASE_BASECONF_BUILD_DIR)/Makefile", var_name("install"), True)} 

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_BASECONF_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}
.NOTPARALLEL: