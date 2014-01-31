##mtl
${local_namespace("host.elfkickers")}

${Package('$(HOST_BUILD_DIR)/ELFkickers-$(HOST_ELFKICKERS_VERSION)', '', '3.0a', "http://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-$(HOST_ELFKICKERS_VERSION).tar.gz", "$(HOST_ROOT_DIR)/bin/sstrip")}

${DownloadRule("$(HOST_ELFKICKERS_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(HOST_ELFKICKERS_FILE)", "$(HOST_BUILD_DIR)", "$(HOST_ELFKICKERS_BUILD_DIR)/Makefile")}

${MakeRule('CFLAGS="" CXXFLAGS=""', 'prefix=$(HOST_ROOT_DIR)', "$(HOST_ELFKICKERS_BUILD_DIR)", "all", "$(HOST_ELFKICKERS_BUILD_DIR)/sstrip/sstrip", "$(HOST_ELFKICKERS_UNPACK)", var_name("build"))}
	#Install needs these
	$(MKDIR) $(HOST_ROOT_DIR)/bin
	$(MKDIR) $(HOST_ROOT_DIR)/share/man/man1
	
${MakeRule('CFLAGS="" CXXFLAGS=""', 'prefix=$(HOST_ROOT_DIR)', "$(HOST_ELFKICKERS_BUILD_DIR)", "install", "$(HOST_ROOT_DIR)/bin/sstrip", "$(HOST_ELFKICKERS_BUILD)", var_name("install"))}

#Add to targets
HOST_INSTALL_TARGETS += $(HOST_ELFKICKERS_INSTALL)
HOST_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: