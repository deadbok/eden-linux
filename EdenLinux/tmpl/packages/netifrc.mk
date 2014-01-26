#mtl
${local_namespace("packages.netifrc")}

#Variable with the names of all files in netifrc
${var_name("netifrc_files")} = $(call rwildcard,$(ROOT)/packages/netifrc,*)

${Package('$(ROOT)/packages/netifrc', '$(PACKAGES_BUILD_DIR)/netifrc', "x", '', '$(ROOTFS_DIR)/etc/init.d/net.lo')}
	
#Install rule
${py netifrc = MakeRule('$(PACKAGES_ENV)', 'DESTDIR=$(ROOTFS_DIR)', "$(PACKAGES_NETIFRC_BUILD_DIR)", "install", '$(ROOTFS_DIR)/etc/init.d/net.lo', var_name("etc_files", True), var_name("install"), True)} 

${py netifrc.recipe.insert(2,'($(CP) -R $(PACKAGES_NETIFRC_SRC_DIR) $(PACKAGES_BUILD_DIR)/); \n')}

${netifrc}
#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_NETIFRC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: