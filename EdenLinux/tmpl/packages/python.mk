#mtl
${local_namespace("packages.python")}

${Package("$(PACKAGES_BUILD_DIR)/Python-$(PACKAGES_PYTHON_VERSION)", "$(PACKAGES_BUILD_DIR)/Python-$(PACKAGES_PYTHON_VERSION)", "2.6.6", "http://www.python.org/ftp/python/$(PACKAGES_PYTHON_VERSION)/Python-$(PACKAGES_PYTHON_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/python")}

${DownloadRule("$(PACKAGES_PYTHON_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(PACKAGES_PYTHON_FILE)", "$(PACKAGES_BUILD_DIR)", "$(PACKAGES_PYTHON_SRC_DIR)/README")}

${PatchRule("$(PACKAGES_PYTHON_UNPACK)")}
	
${AutoconfRule('', '', "$(PACKAGES_PYTHON_SRC_DIR)", "$(PACKAGES_PYTHON_BUILD_DIR)", "$(PACKAGES_PYTHON_BUILD_DIR)/.host_configured", "$(PACKAGES_PYTHON_UNPACK)", "PACKAGES_PYTHON_HOST_CONFIG")}
	$(TOUCH) $(PACKAGES_PYTHON_SRC_DIR)/.host_configured

${MakeRule('', '', "$(PACKAGES_PYTHON_SRC_DIR)", "python", "$(PACKAGES_PYTHON_SRC_DIR)/hostpython", "$(PACKAGES_PYTHON_HOST_CONFIG)", "PACKAGES_PYTHON_HOST_PYTHON")}
	$(MV) $(PACKAGES_PYTHON_SRC_DIR)/python $(PACKAGES_PYTHON_SRC_DIR)/hostpython

${MakeRule('', '', "$(PACKAGES_PYTHON_SRC_DIR)/Parser", "pgen", "$(PACKAGES_PYTHON_SRC_DIR)/Parser/hostpgen", "$(PACKAGES_PYTHON_HOST_CONFIG)", "PACKAGES_PYTHON_HOST_PGEN")}
	$(MV) $(PACKAGES_PYTHON_SRC_DIR)/Parser/pgen $(PACKAGES_PYTHON_SRC_DIR)/Parser/hostpgen

${MakeRule('', '', "$(PACKAGES_PYTHON_SRC_DIR)", "distclean", "distclean", "$(PACKAGES_PYTHON_HOST_CONFIG)", "PACKAGES_PYTHON_DISTCLEAN")}

PACKAGES_PYTHON_HOST-TOOlS = $(PACKAGES_PYTHON_SRC_DIR)/.host-tools
$(PACKAGES_PYTHON_HOST-TOOlS): $(PACKAGES_PYTHON_HOST_PYTHON) $(PACKAGES_PYTHON_HOST_PGEN)
	$(MAKE) $(PACKAGES_PYTHON_DISTCLEAN)
	$(TOUCH) $(PACKAGES_PYTHON_SRC_DIR)/.host-tools
#	(cd $(PACKAGES_PYTHON_SRC_DIR); \
#		$(PACKAGES_PYTHON_SRC_DIR)/configure\
#	);
#	$(MAKE) -C $(PACKAGES_PYTHON_SRC_DIR) python
#	$(MV) $(PACKAGES_PYTHON_SRC_DIR)/python $(PACKAGES_PYTHON_SRC_DIR)/hostpython
#	$(MAKE) -C $(PACKAGES_PYTHON_SRC_DIR)/Parser pgen
#	$(MV) $(PACKAGES_PYTHON_SRC_DIR)/Parser/pgen $(PACKAGES_PYTHON_SRC_DIR)/Parser/hostpgen
#	$(MAKE) -C $(PACKAGES_PYTHON_SRC_DIR) distclean

#${autoconf('$(PACKAGES_ENV)', '--prefix=/usr --build=$(ARCH_HOST) --host=$(ARCH_TARGET)', "$(PACKAGES_PYTHON_HOST-TOOlS)")}
${AutoconfRule('$(PACKAGES_ENV)', '--prefix=/usr --build=$(ARCH_HOST) --host=$(ARCH_TARGET)', "$(PACKAGES_PYTHON_SRC_DIR)", "$(PACKAGES_PYTHON_BUILD_DIR)", "$(PACKAGES_PYTHON_BUILD_DIR)/Makefile", "$(PACKAGES_PYTHON_HOST-TOOlS) $(PACKAGES_PYTHON_PATCHALL)")}
	$(CP) -r "$(PACKAGES_PYTHON_SRC_DIR)/Lib/plat-linux2" "$(PACKAGES_PYTHON_SRC_DIR)/Lib/plat-linux3"
#Make sure we do not start making host-tools when rerunning the make file
#Patching modifies ./configure making it newer than ./.host_configured
#	$(TOUCH) $(PACKAGES_PYTHON_SRC_DIR)/.host_configured

#${make("$(PACKAGES_ENV)", 'HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes', "all", "$(PACKAGES_PYTHON_BUILD_DIR)/python", "$(PACKAGES_PYTHON_CONFIG)")}
${MakeRule('$(PACKAGES_ENV)', 'HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes', "$(PACKAGES_PYTHON_BUILD_DIR)", "all", "$(PACKAGES_PYTHON_BUILD_DIR)/python", "$(PACKAGES_PYTHON_CONFIG)", "PACKAGES_PYTHON_BUILD")}


#${make("$(PACKAGES_ENV)", 'HOSTPYTHON=./hostpython BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes prefix=$(ROOTFS_DIR)/usr', "install", "$(ROOTFS_DIR)/usr/bin/python", "$(PACKAGES_PYTHON_ALL)")}
${MakeRule('$(PACKAGES_ENV)', 'HOSTPYTHON=./hostpython BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes prefix=$(ROOTFS_DIR)/usr', "$(PACKAGES_PYTHON_BUILD_DIR)", "install", "$(ROOTFS_DIR)/usr/bin/python", "$(PACKAGES_PYTHON_BUILD)", "PACKAGES_PYTHON_INSTALL")}
	
#packages:
#	python:
#		version = 2.6.6
#		dir = Python-${version}/cross_build
#		src_dir = Python-${version}
#		group = development
#		url = http://www.python.org/ftp/python/${version}/Python-${version}.tar.bz2
#	
#		download()
#		unpack(${build_dir.packages}/${src_dir}/configure)
#		patch(${build_dir.packages}/${src_dir}/.patched, ${unpack})
#		host_tools(${build_dir.packages}/${dir}/hostpython, ${patch})
#		{
#			${target}: ${dependencies}
#				(cd ${current_package_dir}; \
#					../configure --prefix=/usr\
#				);
#				${make} -C ${build_dir.packages}/${dir} python
#				mv ${build_dir.packages}/${dir}/python ${build_dir.packages}/${dir}/hostpython
#				${make} -C ${build_dir.packages}/${dir} Parser/pgen
#				mv ${build_dir.packages}/${dir}/Parser/pgen ${build_dir.packages}/${dir}/Parser/hostpgen				
#				${make} -C ${build_dir.packages}/${dir} distclean
#		}
#		config(config_opts = "--prefix=/usr --build=$(ARCH_HOST) --host=$(ARCH_TARGET)", ${build_dir.packages}/${dir}/Makefile, ${host_tools})
#		{
#			${target}: ${dependencies}
#				(cd ${current_package_dir}; \
#					PATH=${path.toolchain} LDFLAGS=$(LDFLAGS) ../configure ${config_opts} \
#				);
#		}
#		build(make_opts = "HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes", ${build_dir.packages}/${dir}/python, ${root}/${build_dir.packages}/${dir}/.dir ${build_dir.packages}/${dir}/Makefile)
#		{
#			${target}: ${dependencies} ${current_package_dir}/Makefile
#				$env_packages LDFLAGS=$(LDFLAGS) $make -C ${current_package_dir} ${make_opts}
#		}
#		install(make_opts = "HOSTPYTHON=./hostpython BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes prefix=${root}/${rootfs_dir}/usr", ${root}/${rootfs_dir}/usr/bin/python, ${build_dir.packages}/${dir}/python)
#		{
#			${target}: ${dependencies} ${current_build_target}
#				$env_packages $make -C ${current_package_dir} install ${make_opts}
#				$touch ${target}
#		}
#		clean()
#		distclean()
#	:python
#:packages

.NOTPARALLEL:
