##mtl
${local_namespace("packages.syslog-ng")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --host=$(ARCH_TARGET) 
${local()}CONFIG_ENV = $(PACKAGES_ENV) 

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/syslog-ng-$(PACKAGES_SYSLOG-NG_VERSION)', '', '3.4.2', "http://www.balabit.com/downloads/files/syslog-ng/sources/3.4.2/source/syslog-ng_$(PACKAGES_SYSLOG-NG_VERSION).tar.gz", "$(ROOTFS_DIR)/bin/syslog-ng")}

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_SYSLOG-NG_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_SYSLOG-NG_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL:
