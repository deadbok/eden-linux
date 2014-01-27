#mtl
${local_namespace("packages.base.openrc")}

#Variable with the names of all files in netifrc
${var_name("openrc_files")} = $(call rwildcard,$(ROOT)/packages/openrc,*)

${Package('$(PACKAGES_BASE_FILE_DIR)/openrc', '$(PACKAGES_BUILD_DIR)/openrc', 'x', '', '$(ROOTFS_DIR)/sbin/openrc')}

#openrc needs /run
${Rule('$(ROOTFS_DIR)/run', '', rule_var_name = var_name('run'))}
	$(MKDIR) $(ROOTFS_DIR)/run
	
#Install rule
${py openrc = MakeRule('$(PACKAGES_ENV)', 'DESTDIR=$(ROOTFS_DIR) BRANDING="$(SYS_NAME) $(uname -s)"', "$(PACKAGES_BASE_OPENRC_BUILD_DIR)", "install", '$(ROOTFS_DIR)/sbin/openrc', '$(PACKAGES_BASE_OPENRC_RUN)', var_name("install"), True)}  

${py openrc.recipe.insert(2,'($(CP) -R $(PACKAGES_BASE_OPENRC_SRC_DIR) $(PACKAGES_BUILD_DIR)/); \n')}

${openrc}
#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_OPENRC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: