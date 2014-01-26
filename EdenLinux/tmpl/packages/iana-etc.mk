#mtl
${local_namespace("packages.iana-etc")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = 
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py iana_etc = AutoconfPackage('$(PACKAGES_BUILD_DIR)/iana-etc-$(PACKAGES_IANA-ETC_VERSION)', '', '2.30', "http://sethwklein.net/iana-etc-$(PACKAGES_IANA-ETC_VERSION).tar.bz2", "$(ROOTFS_DIR)/etc/services")}

${iana_etc.vars()}

${iana_etc.rules['download']}

#New target for the unpack rule
${py iana_etc.rules['unpack'].target = '$(PACKAGES_IANA-ETC_SRC_DIR)/Makefile' }
${iana_etc.rules['unpack']}

#Skip the config step
${py iana_etc.rules['build'].dependencies = ' $(PACKAGES_IANA-ETC_UNPACK)' }
${iana_etc.rules['build']}

${iana_etc.rules['install']}

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_IANA-ETC_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_IANA-ETC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}
.NOTPARALLEL:
