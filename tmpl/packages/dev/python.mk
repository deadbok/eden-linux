#mtl
${local_namespace("packages.dev.python")}

${local()}INSTALL_PARAM = HOSTPYTHON=./hostpython BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes prefix=$(ROOTFS_DIR)/usr
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --build=$(HOST) --host=$(ARCH_TARGET) \
						 --disable-nls --enable-shared
${local()}CONFIG_ENV = $(PACKAGES_ENV) 

${local()}BUILD_PARAM = HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes
${local()}BUILD_ENV = $(PACKAGES_ENV)  

${local()}DEPENDENCIES = 

${py _pyhton = AutoconfPackage('$(PACKAGES_BUILD_DIR)/Python-$(PACKAGES_DEV_PYTHON_VERSION)', '', '3.2.2', "http://www.python.org/ftp/python/$(PACKAGES_DEV_PYTHON_VERSION)/Python-$(PACKAGES_DEV_PYTHON_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/python")}

${_pyhton.vars()}

${_pyhton.rules['download']}

${_pyhton.rules['unpack']}

#The following compiles a pyhton interpeter on the host with the x-compile patch
#Configure for host
${AutoconfRule('', '', "$(PACKAGES_DEV_PYTHON_SRC_DIR)", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)/.host_configured", "$(PACKAGES_DEV_PYTHON_UNPACK)", var_name("host-config"))}
	$(TOUCH) $(PACKAGES_DEV_PYTHON_BUILD_DIR)/.host_configured

#Build python and move it
${MakeRule('', '', "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "python", '$(PACKAGES_DEV_PYTHON_BUILD_DIR)/hostpython', '$(PACKAGES_DEV_PYTHON_HOST-CONFIG)', var_name("host-python"), False)}
	$(MV) $(PACKAGES_DEV_PYTHON_BUILD_DIR)/python $(PACKAGES_DEV_PYTHON_BUILD_DIR)/hostpython

#Build pgen and move it
${MakeRule('', '', "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "Parser/pgen", '$(PACKAGES_DEV_PYTHON_BUILD_DIR)/Parser/hostpgen', '$(PACKAGES_DEV_PYTHON_HOST-CONFIG)', var_name("host-pgen"), False)}
	$(MV) $(PACKAGES_DEV_PYTHON_BUILD_DIR)/Parser/pgen $(PACKAGES_DEV_PYTHON_BUILD_DIR)/Parser/hostpgen

#Clean up again
${MakeRule('', '', "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "distclean", '$(PACKAGES_DEV_PYTHON_SRC_DIR)/.host-tools', '$(PACKAGES_DEV_PYTHON_HOST-PYTHON) $(PACKAGES_DEV_PYTHON_HOST-PGEN)', var_name("host-distclean"), False)}
	$(TOUCH) $(PACKAGES_DEV_PYTHON_SRC_DIR)/.host-tools

#Splice the python host generation steps in before the patch
${py _pyhton.rules['patchall'].dependencies += ' $(PACKAGES_DEV_PYTHON_HOST-DISTCLEAN)'}

${_pyhton.rules['patchall']}

#Make sure we do not start making host-tools when rerunning the make file
#Patching modifies ./configure making it newer than ./.host_configured
${_pyhton.rules['config']}

${_pyhton.rules['build']}

${_pyhton.rules['install']}

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_DEV_PYTHON_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

#${Package("$(PACKAGES_BUILD_DIR)/Python-$(PACKAGES_DEV_PYTHON_VERSION)", "$(PACKAGES_BUILD_DIR)/Python-$(PACKAGES_DEV_PYTHON_VERSION)", "2.6.6", "http://www.python.org/ftp/python/$(PACKAGES_DEV_PYTHON_VERSION)/Python-$(PACKAGES_DEV_PYTHON_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/python")}
#
#${DownloadRule("$(PACKAGES_DEV_PYTHON_URL)")}
#
#${UnpackRule("$(DOWNLOAD_DIR)/$(PACKAGES_DEV_PYTHON_FILE)", "$(PACKAGES_BUILD_DIR)", "$(PACKAGES_DEV_PYTHON_SRC_DIR)/README")}
#
#${PatchRule("$(PACKAGES_DEV_PYTHON_UNPACK)")}
#	
#${AutoconfRule('', '', "$(PACKAGES_DEV_PYTHON_SRC_DIR)", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)/.host_configured", "$(PACKAGES_DEV_PYTHON_UNPACK)", "PACKAGES_DEV_PYTHON_HOST_CONFIG")}
#	$(TOUCH) $(PACKAGES_DEV_PYTHON_SRC_DIR)/.host_configured
#
#${MakeRule('', '', "$(PACKAGES_DEV_PYTHON_SRC_DIR)", "python", "$(PACKAGES_DEV_PYTHON_SRC_DIR)/hostpython", "$(PACKAGES_DEV_PYTHON_HOST_CONFIG)", "PACKAGES_DEV_PYTHON_HOST_PYTHON")}
#	$(MV) $(PACKAGES_DEV_PYTHON_SRC_DIR)/python $(PACKAGES_DEV_PYTHON_SRC_DIR)/hostpython
#
#${MakeRule('', '', "$(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser", "pgen", "$(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser/hostpgen", "$(PACKAGES_DEV_PYTHON_HOST_CONFIG)", "PACKAGES_DEV_PYTHON_HOST_PGEN")}
#	$(MV) $(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser/pgen $(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser/hostpgen
#
#${MakeRule('', '', "$(PACKAGES_DEV_PYTHON_SRC_DIR)", "distclean", "host-distclean", "$(PACKAGES_DEV_PYTHON_HOST_CONFIG)", "PACKAGES_DEV_PYTHON_DISTCLEAN")}
#
#PACKAGES_DEV_PYTHON_HOST-TOOlS = $(PACKAGES_DEV_PYTHON_SRC_DIR)/.host-tools
#$(PACKAGES_DEV_PYTHON_HOST-TOOlS): $(PACKAGES_DEV_PYTHON_HOST_PYTHON) $(PACKAGES_DEV_PYTHON_HOST_PGEN)
#	$(MAKE) $(PACKAGES_DEV_PYTHON_DISTCLEAN)
#	$(TOUCH) $(PACKAGES_DEV_PYTHON_SRC_DIR)/.host-tools
##	(cd $(PACKAGES_DEV_PYTHON_SRC_DIR); \
##		$(PACKAGES_DEV_PYTHON_SRC_DIR)/configure\
##	);
##	$(MAKE) -C $(PACKAGES_DEV_PYTHON_SRC_DIR) python
##	$(MV) $(PACKAGES_DEV_PYTHON_SRC_DIR)/python $(PACKAGES_DEV_PYTHON_SRC_DIR)/hostpython
##	$(MAKE) -C $(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser pgen
##	$(MV) $(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser/pgen $(PACKAGES_DEV_PYTHON_SRC_DIR)/Parser/hostpgen
##	$(MAKE) -C $(PACKAGES_DEV_PYTHON_SRC_DIR) distclean
#
##${autoconf('$(PACKAGES_ENV)', '--prefix=/usr --build=$(ARCH_HOST) --host=$(ARCH_TARGET)', "$(PACKAGES_DEV_PYTHON_HOST-TOOLS)")}
#${AutoconfRule('$(PACKAGES_ENV)', '--prefix=/usr --build=$(ARCH_HOST) --host=$(ARCH_TARGET)', "$(PACKAGES_DEV_PYTHON_SRC_DIR)", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)/Makefile", "$(PACKAGES_DEV_PYTHON_HOST-TOOlS) $(PACKAGES_DEV_PYTHON_PATCHALL)")}
#	$(CP) -r "$(PACKAGES_DEV_PYTHON_SRC_DIR)/Lib/plat-linux2" "$(PACKAGES_DEV_PYTHON_SRC_DIR)/Lib/plat-linux3"
##Make sure we do not start making host-tools when rerunning the make file
##Patching modifies ./configure making it newer than ./.host_configured
##	$(TOUCH) $(PACKAGES_DEV_PYTHON_SRC_DIR)/.host_configured
#
##${make("$(PACKAGES_ENV)", 'HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes', "all", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)/python", "$(PACKAGES_DEV_PYTHON_CONFIG)")}
#${MakeRule('$(PACKAGES_ENV)', 'HOSTPYTHON=./hostpython HOSTPGEN=./Parser/hostpgen BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes', "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "all", "$(PACKAGES_DEV_PYTHON_BUILD_DIR)/python", "$(PACKAGES_DEV_PYTHON_CONFIG)", "PACKAGES_DEV_PYTHON_BUILD")}
#
#
##${make("$(PACKAGES_ENV)", 'HOSTPYTHON=./hostpython BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes prefix=$(ROOTFS_DIR)/usr', "install", "$(ROOTFS_DIR)/usr/bin/python", "$(PACKAGES_DEV_PYTHON_ALL)")}
#${MakeRule('$(PACKAGES_ENV)', 'HOSTPYTHON=./hostpython BLDSHARED="$(ARCH_TARGET)-gcc -shared" CROSS_COMPILE=$(ARCH_TARGET)- CROSS_COMPILE_TARGET=yes prefix=$(ROOTFS_DIR)/usr', "$(PACKAGES_DEV_PYTHON_BUILD_DIR)", "install", "$(ROOTFS_DIR)/usr/bin/python", "$(PACKAGES_DEV_PYTHON_BUILD)", "PACKAGES_DEV_PYTHON_INSTALL")}
#	

.NOTPARALLEL:
