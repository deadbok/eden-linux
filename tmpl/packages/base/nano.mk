#mtl
${local_namespace("packages.base.nano")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) --host=$(ARCH_TARGET) --enable-tiny --program-prefix=
${local()}CONFIG_ENV = $(PACKAGES_ENV) CPPFLAGS=-I$(TOOLCHAIN_ROOT_DIR)/usr/include 

${local()}BUILD_PARAM = CPPFLAGS=-I$(TOOLCHAIN_ROOT_DIR)/usr/include
${local()}BUILD_ENV = $(PACKAGES_ENV) CPPFLAGS=-I$(TOOLCHAIN_ROOT_DIR)/usr/include

${local()}DEPENDENCIES = $(PACKAGES_BASE_NCURSES_INSTALL)

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/nano-$(PACKAGES_BASE_NANO_VERSION)', '', '2.2.5', "http://www.nano-editor.org/dist/v2.2/nano-$(PACKAGES_BASE_NANO_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/nano")}

#Add to targets	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BASE_NANO_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: