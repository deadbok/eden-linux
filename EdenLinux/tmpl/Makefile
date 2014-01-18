#mtl

include colors.mk
include config.mk
include functions.mk

#Get the userid
UID := $(shell id -u)

#Directories
ROOT = $(shell pwd)
BUILD_DIR := $(ROOT)/build
DOWNLOAD_DIR := $(BUILD_DIR)/dl
IMAGES_DIR := $(BUILD_DIR)/images
ROOTFS_DIR := $(BUILD_DIR)/rootfs
STRIPPED_ROOTFS_DIR := $(BUILD_DIR)/stripped_rootfs
#template_dir = templates
ETC_DIR := $(ROOTFS_DIR)/etc
TEMP_DIR := $(BUILD_DIR)/tmp

SERVICES :=

$(DOWNLOAD_DIR):
	$(MKDIR) $(DOWNLOAD_DIR)
	
$(IMAGES_DIR):
	$(MKDIR) $(IMAGES_DIR)
	
$(ROOTFS_DIR):
	$(MKDIR) $(ROOTFS_DIR)

$(STRIPPED_ROOTFS_DIR): $(TEMP_DIR) $(TEMP_DIR)/.stripped_rootfs_dir

$(TEMP_DIR)/.stripped_rootfs_dir:
	$(MKDIR) $(STRIPPED_ROOTFS_DIR)
	$(TOUCH) $@

$(TEMP_DIR):
	$(MKDIR) $(TEMP_DIR)

include commands.mk

include toolchain/toolchain.mk
include packages/packages.mk
include target/target.mk

.PHONY: all
all: $(DOWNLOAD_DIR) $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR) $(TOOLCHAIN_INSTALL) $(PACKAGES_BUILD)
	$(TOUCH) $(TEMP_DIR)/.all

#Cry out if trying install before all
$(TEMP_DIR)/.all:
	$(error Make target 'all' first)

INSTALL := $(PACKAGES_INSTALL) $(TARGET_INSTALL)

.PHONY: install
install: $(TEMP_DIR)/.all 
ifeq ($(UID), 0)
	$(MAKE) $(INSTALL)
else
	$(error You need to be root)
endif

.PHONY: clean
clean: $(CLEAN_TARGETS) toolchain-distclean
	-$(RM) -Rf $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR)

.PHONY: distclean
${Rule("distclean", "")}
	-$(RM) -Rf $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR)
	$(MAKE) $(DISTCLEAN_TARGETS)

.NOTPARALLEL:

#TODO: Clean rules
#clean(clean, ${clean.toolchain})
#{
#    ${target}: ${dependencies}
#}
