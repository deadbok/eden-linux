#mtl

#Name of the distro
SYS_NAME := EdenLinux
#Compress man pages
COMPRESS_MAN_PAGES = 1
#Strip target binaries
STRIP_TARGET = 1
#Delete header files from the target
REMOVE_HEADERS = 1
#Name of a file that list files to be removed from the target filesystem
TARGET_REMOVE_FILES =

TARGET :=
ARCH :=
KERNEL_ARCH := 
ARCH_TARGET := 
HOST := $(shell gcc -dumpmachine)
ABI=

#Size of the final root image in Mb
IMAGE_SIZE = 450
#Image name
TARGET_IMAGE_FILENAME = root.img

#Make processes to run in parrallel when possible
MAKE_PROCESSES = 4
MAKE_LOAD =

#Directories
ROOT = $(shell pwd)
BUILD_DIR := $(ROOT)/build
DOWNLOAD_DIR := $(BUILD_DIR)/dl
IMAGES_DIR := $(BUILD_DIR)/images
ROOTFS_DIR := $(BUILD_DIR)/rootfs
IMAGE_ROOTFS_DIR := $(BUILD_DIR)/image_rootfs
STRIPPED_ROOTFS_DIR := $(BUILD_DIR)/stripped_rootfs
#template_dir = templates
ETC_DIR := $(ROOTFS_DIR)/etc
TEMP_DIR := $(BUILD_DIR)/tmp

#List of packages to install
PACKAGE_LIST = 

#Override with board specific values
include target/config/qemux86.mk