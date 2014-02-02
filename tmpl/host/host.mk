#mtl
${local_namespace('host')}

${local()}FILE_DIR = $(ROOT)/host
${local()}BUILD_DIR = $(BUILD_DIR)/host_$(HOST)_build
${local()}ROOT_DIR := $(BUILD_DIR)/host_$(HOST)

${local()}CMDS := LIBTOOL="$(HOST_ROOT_DIR)/bin/libtool"
${local()}PATH := $(HOST_ROOT_DIR)/bin

$(HOST_BUILD_DIR):
	$(MKDIR) $(HOST_BUILD_DIR)

include host/libtool.mk
include host/pkg-config.mk

${local()}INSTALL := $(HOST_BUILD_DIR) $(HOST_INSTALL_TARGETS)

.PHONY: host-distclean
${Rule("host-distclean")}
	-$(RM) -R $(HOST_BUILD_DIR) $(HOST_ROOT_DIR)
	
DISTCLEAN_TARGETS += host-distclean