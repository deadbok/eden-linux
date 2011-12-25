#mtl

#Compress man pages
COMPRESS_MAN_PAGES = 1

VERBOSE = 0
STRIP_TARGET = 1
MAKE_PROCESSES=2
REMOVE_HEADERS = 1

TARGET := x86
ARCH := i686
KERNEL_ARCH := i386
ARCH_TARGET := $(ARCH)-pc-linux-uclibc
#Host type definition
HOST_ARCH := i686
HOST := $(HOST_ARCH)-pc-linux-gnu

ROOT_DEVICE := /dev/sda1
SWAP_DEVICE := /dev/sda2