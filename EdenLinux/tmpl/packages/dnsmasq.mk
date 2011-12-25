#mtl
${local_namespace("packages.dnsmasq")}

${Package("$(PACKAGES_BUILD_DIR)/dnsmasq-$(PACKAGES_DNSMASQ_VERSION)", "", "2.59", "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-$(PACKAGES_DNSMASQ_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/dnsmasq")}

${DownloadRule("$(PACKAGES_DNSMASQ_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(PACKAGES_DNSMASQ_FILE)", "$(PACKAGES_BUILD_DIR)", "$(PACKAGES_DNSMASQ_SRC_DIR)/Makefile")}

${MakeRule("$(PACKAGES_ENV)", '', "$(PACKAGES_DNSMASQ_BUILD_DIR)", "all", "$(PACKAGES_DNSMASQ_BUILD_DIR)/src/dnsmasq", "$(PACKAGES_DNSMASQ_UNPACK)", var_name("build"))}

${MakeRule("$(PACKAGES_ENV)", 'DESTDIR=$(ROOTFS_DIR) PREFIX=/usr', "$(PACKAGES_DNSMASQ_BUILD_DIR)", "install", "$(ROOTFS_DIR)/usr/sbin/dnsmasq", "$(PACKAGES_DNSMASQ_BUILD)", var_name("install"))}

.NOTPARALLEL: