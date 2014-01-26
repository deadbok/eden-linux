#mtl
${local_namespace("packages.openrc")}

${Package('$(PACKAGES_BUILD_DIR)/openrc', '$(PACKAGES_BUILD_DIR)/openrc', "0.12.x", "https://github.com/OpenRC/openrc.git", '$(ROOTFS_DIR)/sbin/openrc')}

#Clone git repositry
${Rule('$(DOWNLOAD_DIR)/openrc/README', rule_var_name=var_name("clone"))}
	$(MKDIR) $(DOWNLOAD_DIR)/openrc
	$(GIT) clone --depth=1 $(PACKAGES_OPENRC_URL) $(DOWNLOAD_DIR)/openrc
	#$(CD) $(DOWNLOAD_DIR)/openrc; $(GIT) checkout openrc-$(PACKAGES_OPENRC_VERSION); 

#Copy sources
${Rule('$(PACKAGES_OPENRC_SRC_DIR)/README', '$(PACKAGES_OPENRC_CLONE)', rule_var_name = var_name('copy-src'))}
	$(CP) -R $(DOWNLOAD_DIR)/openrc $(PACKAGES_BUILD_DIR)/
	
#Create a rule to patch zlib
${PatchRule("$(PACKAGES_OPENRC_COPY-SRC)")}

#openrc needs /run
${Rule('$(ROOTFS_DIR)/run', '', rule_var_name = var_name('run'))}
	$(MKDIR) $(ROOTFS_DIR)/run
	
#Install rule
${MakeRule('$(PACKAGES_ENV)', 'DESTDIR=$(ROOTFS_DIR) BRANDING="$(SYS_NAME) $(uname -s)"', "$(PACKAGES_OPENRC_BUILD_DIR)", "install", '$(ROOTFS_DIR)/sbin/openrc', '$(PACKAGES_OPENRC_PATCHALL) $(PACKAGES_OPENRC_RUN)', var_name("install"), True)} 

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_OPENRC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: