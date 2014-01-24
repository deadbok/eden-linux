#mtl
${local_namespace("packages.bootscripts")}

#These scripts depends on OpenRC
${local()}DEPENDENCIES := $(PACKAGES_OPENRC_INSTALL)

SERVICES += syslog clock mountroot localmount network modules

${Package("$(ROOT)/packages/bootscripts", "$(ROOT)/packages/bootscripts", "1.0", "", "$(ROOTFS_DIR)/etc/inittab")}

${MakeRule("", "DESTDIR=$(ROOTFS_DIR)", "$(PACKAGES_BOOTSCRIPTS_BUILD_DIR)", "install", "$(ROOTFS_DIR)/etc/inittab", "", var_name("install"))} 

${local()}DEPENDENCIES := $(PACKAGES_OPENRC_INSTALL)

PACKAGES_INSTALL_TARGETS += $(PACKAGES_BOOTSCRIPTS_DEPENDENCIES) $(PACKAGES_BOOTSCRIPTS_INSTALL)
PACKAGES_NAME_TARGETS += bootscripts

.NOTPARALLEL: