#mtl

#Compress man pages
COMPRESS_MAN_PAGES = 1

STRIP_TARGET = 1
MAKE_PROCESSES=2
REMOVE_HEADERS = 1

TARGET := armv6j
ARCH := arm
KERNEL_ARCH := arm
ARCH_TARGET := $(ARCH)-unknown-linux-uclibcgnueabihf
#Host type definition
#HOST_ARCH := i686
#HOST := $(HOST_ARCH)-pc-linux-gnu
HOST := $(shell gcc -dumpmachine)
ABI=32

ROOT_DEVICE := /dev/sda1
SWAP_DEVICE := /dev/sda2

MAKE_PROCESSES = 2
MAKE_LOAD =

#Override with board specific values
include target/config/rpi.mk