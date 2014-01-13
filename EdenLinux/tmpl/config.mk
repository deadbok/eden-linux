#mtl

#Compress man pages
COMPRESS_MAN_PAGES = 1
#Strip target binaries
STRIP_TARGET = 1
#Delete header files from the target
REMOVE_HEADERS = 1

TARGET := armv6j
ARCH := arm
KERNEL_ARCH := arm
ARCH_TARGET := $(ARCH)-unknown-linux-uclibcgnueabihf
HOST := $(shell gcc -dumpmachine)
ABI=32

ROOT_DEVICE := /dev/sda1
SWAP_DEVICE := /dev/sda2

#Make processes to run in parrallel when possible
MAKE_PROCESSES = 2
MAKE_LOAD =

#Override with board specific values
include target/config/rpi.mk