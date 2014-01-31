##mtl
${local_namespace("toolchain.elfkickers")}

${Package('$(TOOLCHAIN_BUILD_DIR)/ELFkickers-$(TOOLCHAIN_ELFKICKERS_VERSION)', '', '3.0a', "http://www.muppetlabs.com/~breadbox/pub/software/ELFkickers-$(TOOLCHAIN_ELFKICKERS_VERSION).tar.gz", "$(TOOLCHAIN_ROOT_DIR)/bin/sstrip")}

${DownloadRule("$(TOOLCHAIN_ELFKICKERS_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(TOOLCHAIN_ELFKICKERS_FILE)", "$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_ELFKICKERS_BUILD_DIR)/Makefile")}

${MakeRule('CFLAGS="" CXXFLAGS=""', 'prefix=$(TOOLCHAIN_ROOT_DIR)', "$(TOOLCHAIN_ELFKICKERS_BUILD_DIR)", "all", "$(TOOLCHAIN_ELFKICKERS_BUILD_DIR)/sstrip/sstrip", "$(TOOLCHAIN_ELFKICKERS_UNPACK)", var_name("build"))}

${MakeRule('CFLAGS="" CXXFLAGS=""', 'prefix=$(TOOLCHAIN_ROOT_DIR)', "$(TOOLCHAIN_ELFKICKERS_BUILD_DIR)", "install", "$(TOOLCHAIN_ROOT_DIR)/bin/sstrip", "$(TOOLCHAIN_ELFKICKERS_BUILD)", var_name("install"))}

.NOTPARALLEL: