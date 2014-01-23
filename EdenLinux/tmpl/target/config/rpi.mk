#mtl
${local_namespace("target")}

#Raspberry Pi specifi settings
TARGET := rpi
ARCH := arm
KERNEL_ARCH := arm
ARCH_TARGET := $(ARCH)-unknown-linux-uclibcgnueabihf
ABI=32
FLOAT_SUPPORT := hard
FPU_VER := vfp
CPU_ARCH := armv6j

#Real version number used when installing modules
RPI_KERNEL_VERSION := 3.10.27+

${local()}CFLAGS := "-O2 -pipe -march=armv6j -mfpu=vfp -mfloat-abi=hard"
${local()}CXXFLAGS := $(TARGET_CFLAGS)
${local()}LDFLAGS := "-mfpu=vfp -mfloat-abi=hard"

BOOT_DEVICE := /dev/mmcblk0p1
ROOT_DEVICE := /dev/mmcblk0p2
SWAP_DEVICE := /dev/mmcblk0p3

${local()}PROCESSOR = armv6j
${local()}FILE_SYSTEM = iso
${local()}UCLIBC_CONFIG = $(ROOT)/target/config/rpi/config/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/config/rpi/config/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/config/rpi/config/busybox_config

#Boot partition size
TARGET_IMAGE_BOOT_SIZE = 64
#Image name
TARGET_IMAGE_FILENAME = rpi.img
