##mtl
${local_namespace("packages.mc")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --host=$(ARCH_TARGET)
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py iproute2 = AutoconfPackage('$(PACKAGES_BUILD_DIR)/mc-$(PACKAGES_MC_VERSION)', '', '4.8.11', "http://ftp.midnight-commander.org/mc-$(PACKAGES_MC_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/bin/mc")}

${iproute2}

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_MC_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_MC_INSTALL)
PACKAGES_NAME_TARGETS += mc

.NOTPARALLEL: