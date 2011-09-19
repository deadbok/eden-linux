#mtl
TARGET := x86
ARCH := i686
KERNEL_ARCH := i386
ARCH_TARGET := $(ARCH)-pc-linux-uclibc
#Host type definition
HOST_ARCH := i686
HOST := $(HOST_ARCH)-pc-linux-gnu
#Get the userid
UID := $(shell id -u)
ROOT_DEVICE := /dev/sda1
SWAP_DEVICE := /dev/sda2

#Directories
ROOT := $(shell pwd)
BUILD_DIR := $(ROOT)/build
DOWNLOAD_DIR := $(BUILD_DIR)/dl
IMAGES_DIR := images
ROOTFS_DIR := $(BUILD_DIR)/rootfs
#template_dir = templates
ETC_DIR := $(ROOTFS_DIR)/etc
TEMP_DIR := $(BUILD_DIR)/tmp

$(DOWNLOAD_DIR):
	$(MKDIR) $(DOWNLOAD_DIR)
	
$(IMAGES_DIR):
	$(MKDIR) $(IMAGES_DIR)
	
$(ROOTFS_DIR):
	$(MKDIR) $(ROOTFS_DIR)

include commands.mk

include toolchain/toolchain.mk
include packages/packages.mk
include target/target.mk

all: $(DOWNLOAD_DIR) $(IMAGES_DIR) $(ROOTFS_DIR) $(PACKAGES_BUILD)

install: $(PACKAGES_INSTALL) $(TARGET_INSTALL)

#TODO: Clean rules
#clean(clean, ${clean.toolchain})
#{
#    ${target}: ${dependencies}
#}
