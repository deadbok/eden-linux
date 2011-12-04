#mtl
${local_namespace("packages.aufs-util")}

${Package("$(PACKAGES_BUILD_DIR)/aufs-util", "", "3.0", "git://aufs.git.sourceforge.net/gitroot/aufs/aufs-util.git", "$(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)")}

${Rule('$(DOWNLOAD_DIR)/aufs-util/README', rule_var_name=var_name("clone"))}
	$(GIT) clone $(PACKAGES_AUFS-UTIL_URL) $(DOWNLOAD_DIR)/aufs-util

${Rule('$(DOWNLOAD_DIR)/aufs-util/Makefile', "$(PACKAGES_AUFS-UTIL_CLONE)", rule_var_name=var_name("checkout"))}
	($(CD) $(DOWNLOAD_DIR)/aufs-util; $(GIT) checkout origin/aufs$(PACKAGES_AUFS-UTIL_VERSION));


${Rule('$(TEMP_DIR)/.aufs-util-download', "$(PACKAGES_AUFS-UTIL_CHECKOUT)", rule_var_name=var_name("download"))}
	$(TOUCH) $@

${Rule('$(PACKAGES_AUFS-UTIL_SRC_DIR)/Makefile', "$(PACKAGES_AUFS-UTIL_DOWNLOAD)", rule_var_name=var_name("copy-src"))}
	-$(MKDIR) $(PACKAGES_AUFS-UTIL_SRC_DIR)
	$(CP) -R $(DOWNLOAD_DIR)/aufs-util/* $(PACKAGES_AUFS-UTIL_SRC_DIR)

${PatchRule("$(PACKAGES_AUFS-UTIL_COPY-SRC)")}

${MakeRule('$(PACKAGES_ENV)', 'HOSTCC="gcc" CPPFLAGS="-I $(ROOTFS_DIR)/usr/include" DESTDIR="$(ROOTFS_DIR)"', "$(PACKAGES_AUFS-UTIL_BUILD_DIR)", "all", "$(PACKAGES_AUFS-UTIL_BUILD_DIR)/auchk", "$(PACKAGES_AUFS_PATCH) $(PACKAGES_AUFS-UTIL_PATCHALL)", var_name("build"))}

${MakeRule('$(PACKAGES_ENV)', 'HOSTCC="gcc" CPPFLAGS="-I $(ROOTFS_DIR)/usr/include" DESTDIR="$(ROOTFS_DIR)"', "$(PACKAGES_AUFS-UTIL_BUILD_DIR)", "install", "$(ROOTFS_DIR)/usr/bin/auchk", "$(PACKAGES_AUFS-UTIL_BUILD)", var_name("install"))}
	
.NOTPARALLEL: