#mtl
${local_namespace("target")}

#mtl
${local_namespace("target")}

TARGET := qemux86
ARCH := i686
KERNEL_ARCH := x86
ARCH_TARGET := $(ARCH)-linux-uclibc

BOOT_DEVICE := /dev/sda1
ROOT_DEVICE := /dev/sda2
SWAP_DEVICE := /dev/sda3

${local()}PROCESSOR = armv6j
${local()}FILE_SYSTEM = iso
${local()}UCLIBC_CONFIG = $(ROOT)/target/config/rpi/config/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/config/rpi/config/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/config/rpi/config/busybox_config

#Boot partition size
TARGET_IMAGE_BOOT_SIZE = 64
#Image name
TARGET_IMAGE_FILENAME = rpi.img

${local()}UCLIBC_CONFIG = $(ROOT)/target/config/qemux86/config/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/config/qemux86/config/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/config/qemux86/config/busybox_config

.NOTPARALLEL: