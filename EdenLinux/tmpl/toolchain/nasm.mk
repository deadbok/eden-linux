#mtl
${local_namespace("toolchain.nasm")}

${package("$(TOOLCHAIN_BUILD_DIR)/nasm-$(TOOLCHAIN_NASM_VERSION)", "", "2.08.02", "nasm-$(TOOLCHAIN_NASM_VERSION).tar.bz2", "http://www.nasm.us/pub/nasm/releasebuilds/$(TOOLCHAIN_NASM_VERSION)/$(TOOLCHAIN_NASM_FILE)")}

${download}

${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_NASM_SRC_DIR)/configure")}

${autoconf('$(TOOLCHAIN_ENV)', '--prefix=$(TOOLCHAIN_ROOT_DIR)', "")}

${make('$(TOOLCHAIN_ENV)', "", "all", "$(TOOLCHAIN_NASM_BUILD_DIR)/nasm", "$(TOOLCHAIN_NASM_CONFIG)")}

${make('$(TOOLCHAIN_ENV)', "", "install", "$(TOOLCHAIN_ROOT_DIR)/bin/nasm", "$(TOOLCHAIN_NASM_ALL)")}

#toolchain:
#	nasm:
#		dir = nasm-${version}
#		group = toolchain
#		version = 2.08.02
#		url = http://www.nasm.us/pub/nasm/releasebuilds/${version}/nasm-${version}.tar.bz2
#	
#		download()
#		unpack(${build_dir.toolchain}/${dir}/configure)
#		config(config_opts = "--prefix=${root}/${root_dir.toolchain}", ${root}/${build_dir.toolchain}/${dir}/Makefile, ${unpack} ${install.gcc-cross.toolchain})
#		build(${build_dir.toolchain}/${dir}/nasm, ${root}/${build_dir.toolchain}/${dir}/Makefile)
#		install(${root_dir.toolchain}/bin/nasm, ${build_dir.toolchain}/${dir}/nasm)
#		clean()
#		distclean()
#	:nasm
#:toolchain