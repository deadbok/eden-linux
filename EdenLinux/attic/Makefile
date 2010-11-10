MACHTYPE := x86_64-pc-linux-gnu #$(shell gcc -dumpmachine)

#Host type definition
EDEN_BUILD_HOST := $(MACHTYPE)

#Target arch definitions
EDEN_ARCH := i686
EDEN_CPU := c3-2
EDEN_ARCH_TARGET := $(EDEN_ARCH)-pc-linux-uclibc
EDEN_KERNEL_ARCH := i386
EDEN_IMAGETYPE := ext2

#Hostname of target
EDEN_HOSTNAME := eve
EDEN_DOMAINNAME := oblivion.linuxsecured.net

#Verbose messages from commands
ifeq ($(VERBOSE),)
	VERBOSE_FLAG := 
else
	VERBOSE_FLAG := -v
endif

#Compiler flags
CF_OPTIMIZE := -Os
CF_ABI := -m32
CFLAGS := $(CF_OPTIMIZE) $(CF_ABI)

#Commands
MAKE := $(MAKE) -j4
CP = cp $(VERBOSE_FLAG)
CC := $(EDEN_ARCH_TARGET)-gcc $(CFLAGS)
LD := $(EDEN_ARCH_TARGET)-ld
WGET := wget
AWK := gawk

#Where to install the root file-system
EDEN_ROOTFS_PATH := /mnt/temp

#Directories
ROOT := $(shell pwd)
ROOTFS := $(ROOT)/rootfs
DLDIR := $(ROOT)/dl
IMAGE_DIR := $(ROOT)/images
TARGETS_DIR := $(ROOT)/target
TEMP_DIR := $(ROOT)/tmp

PACKAGE_DIR := $(ROOT)/packages
ARCH_BUILD_DIR := $(ROOT)/build-$(EDEN_ARCH)

TOOLCHAIN_DIR := $(ROOT)/toolchain
TOOLCHAIN_BUILD_DIR := $(ROOT)/toolchain-build-$(EDEN_ARCH)
TOOLCHAIN_ROOT_DIR := $(ROOTFS)/$(EDEN_ARCH_TARGET)
TOOLCHAIN_PATH := $(TOOLCHAIN_ROOT_DIR)/bin:$(PATH)

#Linker flags
LDFLAGS = "-Wl,-rpath,$(TOOLCHAIN_ROOT_DIR)/lib"

#RAW image file
EDEN_IMAGE_FILE = $(IMAGE_DIR)/root.img
EDEN_IMAGE_SIZE := 128
EDEN_IMAGE_SECTORS := 63
EDEN_IMAGE_HEADS := 16
EDEN_IMAGE_BPS	:= 512
EDEN_IMAGE_CYLINDERS = $(shell $(AWK) 'BEGIN { printf "%d", (($(EDEN_IMAGE_SIZE) * 1024 * 1024) / (($(EDEN_IMAGE_SECTORS) * $(EDEN_IMAGE_BPS)) + $(EDEN_IMAGE_HEADS))) }')
EDEN_PARTIOTION_SIZE := 120

#Disk devices
EDEN_ROOT_DEVICE = /dev/sda1
EDEN_SWAP_DEVICE = $(IMAGE_DIR)/swap.img

#Toolchain  names
TOOLCHAIN_CC := $(EDEN_ARCH_TARGET)-gcc
TOOLCHAIN_CXX := $(EDEN_ARCH_TARGET)-g++
TOOLCHAIN_AR := $(EDEN_ARCH_TARGET)-ar
TOOLCHAIN_AS := $(EDEN_ARCH_TARGET)-as
TOOLCHAIN_LD := $(EDEN_ARCH_TARGET)-ld
TOOLCHAIN_RANLIB := $(EDEN_ARCH_TARGET)-ranlib
TOOLCHAIN_READELF := $(EDEN_ARCH_TARGET)-readelf
TOOLCHAIN_STRIP := $(EDEN_ARCH_TARGET)-strip

#Environtment for calling the toolchain
TOOLCHAIN := CC="$(TOOLCHAIN_CC) -I $(ROOTFS)/usr/include" CXX="$(TOOLCHAIN_CXX)" AR="$(TOOLCHAIN_AR)"\
			  LD="$(TOOLCHAIN_CC)" RANLIB="$(TOOLCHAIN_RANLIB)" READELF="$(TOOLCHAIN_READELF)"\
			  STRIP="$(TOOLCHAIN_STRIP)" PATH="$(TOOLCHAIN_PATH)" 

#Get the userid
UID := $(shell id -u)

#Include package targets
include packages/*/*.mk

#include toolchain targets
include toolchain/*/*.mk

#include target types
include target/*.mk

#Rules
.PHONY all:
all: world 

world: $(ARCH_BUILD_DIR) $(TOOLCHAIN_BUILD_DIR) $(TOOLCHAIN_ROOT_DIR) $(DLDIR) $(IMAGE_DIR) $(ROOTFS) $(ROOTFS)/boot $(ROOTFS)/sys $(ROOTFS)/proc $(ROOTFS)/root $(TOOLCHAIN_TARGETS) $(TARGETS) 

$(ARCH_BUILD_DIR):
	mkdir -p $(ARCH_BUILD_DIR)

$(DLDIR):
	mkdir -p $(DLDIR)
	
$(ROOTFS):
	mkdir -p $(ROOTFS)

$(ROOTFS)/boot:
	mkdir -p $(ROOTFS)/boot

$(ROOTFS)/proc:
	mkdir -p $(ROOTFS)/proc
	
$(ROOTFS)/sys:
	mkdir -p $(ROOTFS)/sys
	
$(ROOTFS)/root:
	mkdir -p $(ROOTFS)/root

$(TOOLCHAIN_BUILD_DIR):
	mkdir -p $(TOOLCHAIN_BUILD_DIR)
	
$(TOOLCHAIN_ROOT_DIR):
	mkdir -p $(TOOLCHAIN_ROOT_DIR)

$(IMAGE_DIR):
	mkdir -p $(IMAGE_DIR)
	
$(TEMP_DIR):
	mkdir -p $(TEMP_DIR)
	
.PHONY install:
install: check-root $(INSTALL_TARGETS)

.PHONY check-root:
check-root:
ifneq ($(UID), 0)
	$(error You must be root to install EdenLinux)
endif	

.PHONY clean:
clean: $(CLEAN_TARGETS)
	rm -fR $(VERBOSE_FLAG) $(ROOTFS) $(ARCH_BUILD_DIR) $(TOOLCHAIN_BUILD_DIR) $(TOOLCHAIN_ROOT_DIR)

.PHONY toolchain-clean:
toolchain-clean:
	rm -fR $(VERBOSE_FLAG) $(TOOLCHAIN_BUILD_DIR) $(TOOLCHAIN_ROOT_DIR)
	
.PHONY rootfs-clean:
rootfs-clean:
	-rm -fR $(ROOTFS)
	
.PHONY distclean:
distclean: $(DISTCLEAN_TARGETS)
	rm -fR $(VERBOSE_FLAG) $(ROOT)/dl
	rm -fR $(VERBOSE_FLAG) $(ROOTFS) $(ARCH_BUILD_DIR) $(TOOLCHAIN_BUILD_DIR) $(TOOLCHAIN_ROOT_DIR)
