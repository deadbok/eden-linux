#mtl
${local_namespace("host.libtool")}

${local()}INSTALL_PARAM = 
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=$(HOST_ROOT_DIR) --host=$(ARCH_TARGET) --with-sysroot=$(ROOTFS_DIR)
${local()}CONFIG_ENV = $(PACKAGES_ENV) enable_shared=yes

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV)

${AutoconfPackage('$(HOST_BUILD_DIR)/libtool-$(HOST_LIBTOOL_VERSION)', '', '2.4', "ftp://ftp.gnu.org/gnu/libtool/libtool-$(HOST_LIBTOOL_VERSION).tar.xz", "$(HOST_ROOT_DIR)/bin/libtool", "$(HOST_ENV)")}

#Add to targets
HOST_INSTALL_TARGETS += $(HOST_LIBTOOL_INSTALL)
HOST_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: