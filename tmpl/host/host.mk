#mtl
${local_namespace('host')}

${local()}FILE_DIR = $(ROOT)/host
${local()}BUILD_DIR = $(BUILD_DIR)/host_$(HOST)_build
${local()}ROOT_DIR := $(BUILD_DIR)/host_$(HOST)

$(HOST_BUILD_DIR):
	$(MKDIR) $(HOST_BUILD_DIR)

${local()}INSTALL := $(HOST_BUILD_DIR) $(HOST_INSTALL_TARGETS)