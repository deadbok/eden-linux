##mtl

${local_namespace("host.pkg-config")}

${local()}INSTALL_PARAM =
${local()}INSTALL_ENV = 

${local()}CONFIG_PARAM = --prefix=$(HOST_ROOT_DIR) 
${local()}CONFIG_ENV = 

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = 

${AutoconfPackage('$(HOST_BUILD_DIR)/pkg-config-$(HOST_PKG-CONFIG_VERSION)', '', '0.28', "http://pkgconfig.freedesktop.org/releases/pkg-config-$(HOST_PKG-CONFIG_VERSION).tar.gz", "$(HOST_ROOT_DIR)/bin/pkg-config", '')}

#Add to targets
HOST_INSTALL_TARGETS += $(HOST_PKG-CONFIG_INSTALL)
HOST_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: