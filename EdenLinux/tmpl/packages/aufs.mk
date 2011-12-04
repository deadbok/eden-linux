#mtl
${local_namespace("packages.aufs")}

${Package("$(TOOLCHAIN_BUILD_DIR)/aufs3", "", "3.0", "git://aufs.git.sourceforge.net/gitroot/aufs/aufs3-standalone.git", "$(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)")}

${Rule('$(DOWNLOAD_DIR)/aufs3/README', rule_var_name=var_name("clone"))}
	$(GIT) clone $(PACKAGES_AUFS_URL) $(DOWNLOAD_DIR)/aufs3

${Rule('$(DOWNLOAD_DIR)/aufs3/Makefile', "$(PACKAGES_AUFS_CLONE)", rule_var_name=var_name("checkout"))}
	($(CD) $(DOWNLOAD_DIR)/aufs3; $(GIT) checkout origin/aufs$(PACKAGES_AUFS_VERSION));

${Rule('$(TEMP_DIR)/.aufs3-download', "$(PACKAGES_AUFS_CHECKOUT)", rule_var_name=var_name("download"))}
	$(TOUCH) $@

${Rule('$(PACKAGES_AUFS_SRC_DIR)/Makefile', "$(PACKAGES_AUFS_DOWNLOAD)", rule_var_name=var_name("copy-src"))}
	-$(MKDIR) $(PACKAGES_AUFS_SRC_DIR)
	$(CP) -R $(DOWNLOAD_DIR)/aufs3/* $(PACKAGES_AUFS_SRC_DIR)

${Rule('$(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/.aufs', "$(PACKAGES_AUFS_COPY-SRC) $(PACKAGES_KERNEL_LINK-SRC)", rule_var_name=var_name("patch"))}	
	$(PATCH) -p1 -d $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) < $(PACKAGES_AUFS_SRC_DIR)/aufs3-kbuild.patch
	$(PATCH) -p1 -d $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) < $(PACKAGES_AUFS_SRC_DIR)/aufs3-base.patch
	$(PATCH) -p1 -d $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) < $(PACKAGES_AUFS_SRC_DIR)/aufs3-proc_map.patch
	$(PATCH) -p1 -d $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR) < $(PACKAGES_AUFS_SRC_DIR)/aufs3-standalone.patch
	$(CP) -R $(PACKAGES_AUFS_SRC_DIR)/{Documentation,fs} $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)
	$(CP) $(PACKAGES_AUFS_SRC_DIR)/include/linux/aufs_type.h $(TOOLCHAIN_KERNEL-HEADERS_SRC_DIR)/include/linux
	$(TOUCH) $@
	
.NOTPARALLEL: