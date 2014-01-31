#mtl
${local_namespace("target")}

TARGET := qemux86
ARCH := i686
KERNEL_ARCH := x86
ARCH_TARGET := $(ARCH)-linux-uclibc

BOOT_DEVICE := 
ROOT_DEVICE := /dev/sda1
SWAP_DEVICE := /dev/sda2

#Modules to load on boot
KERNEL_MODULES := "e1000"

#Boot partition size
TARGET_IMAGE_BOOT_SIZE = 
#Image name
TARGET_IMAGE_FILENAME = qemux86.img

#Package list
PACKAGE_LIST = $(ROOT)/target/config/qemux86/pkg-list

TARGET_REMOVE_FILES = $(ROOT)/target/config/qemux86/remove_list

${local()}UCLIBC_CONFIG = $(ROOT)/target/config/qemux86/config/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/config/qemux86/config/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/config/qemux86/config/busybox_config

.NOTPARALLEL: