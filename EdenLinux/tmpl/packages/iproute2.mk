#mtl
${local_namespace("packages.iproute2")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --host=$(ARCH_TARGET)
${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${py iproute2 = AutoconfPackage('$(PACKAGES_BUILD_DIR)/iproute2-$(PACKAGES_IPROUTE2_VERSION)', '', '3.8.0', "https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-$(PACKAGES_IPROUTE2_VERSION).tar.xz", "$(ROOTFS_DIR)/usr/bin/i")}

${iproute2}

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_IPROUTE2_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_IPROUTE2_INSTALL)
PACKAGES_NAME_TARGETS += iproute2
.NOTPARALLEL: