#mtl
${local_namespace("toolchain")}
#Toolchain names
${local()}CC := $(ARCH_TARGET)-gcc
${local()}CXX := $(ARCH_TARGET)-g++
${local()}GO := $(ARCH_TARGET)-gccgo
${local()}AR := $(ARCH_TARGET)-ar
${local()}AS := $(ARCH_TARGET)-as
${local()}LD := $(ARCH_TARGET)-ld
${local()}GOLD := $(ARCH_TARGET)-ld.gold
${local()}RANLIB := $(ARCH_TARGET)-ranlib
${local()}READELF := $(ARCH_TARGET)-readelf
${local()}STRIP := $(ARCH_TARGET)-strip


${local()}CFLAGS := "-Os"
${local()}CXXFLAGS := "-Os"

ifdef DEBUG
${local()}CFLAGS := "-g"
${local()}CXXFLAGS := "-g"
endif

${local()}FILE_DIR := $(BUILD_DIR)/toolchain
${local()}BUILD_DIR := $(BUILD_DIR)/toolchain_$(ARCH)_build
${local()}ROOT_DIR := $(BUILD_DIR)/toolchain_$(ARCH)

${local()}PATH := $(TOOLCHAIN_ROOT_DIR)/bin:$(TOOLCHAIN_ROOT_DIR)/gcc-static/bin:$(PATH)
${local()}FLAGS := CFLAGS=$(TOOLCHAIN_CFLAGS) CXXFLAGS=$(TOOLCHAIN_CXXFLAGS)
${local()}CMDS := CC="$(TOOLCHAIN_CC) -I $(TOOLCHAIN_ROOT_DIR)/usr/include" CXX="$(TOOLCHAIN_CXX) -I $(TOOLCHAIN_ROOT_DIR)/usr/include" GO="$(TOOLCHAIN_GO)" AR="$(TOOLCHAIN_AR)" LD="$(TOOLCHAIN_CC)" RANLIB="$(TOOLCHAIN_RANLIB)" READELF="$(TOOLCHAIN_READELF)" STRIP="$(TOOLCHAIN_STRIP)"
#Environtment for calling the toolchain
${local()}ENV := $(TOOLCHAIN_CMDS) PATH=$(TOOLCHAIN_PATH) $(TOOLCHAIN_FLAGS)


$(TOOLCHAIN_BUILD_DIR):
	$(MKDIR) $(TOOLCHAIN_BUILD_DIR)

include toolchain/gcc-cross.mk
include target/fsh.mk

${local()}INSTALL := $(TOOLCHAIN_BUILD_DIR) $(TARGET_FSH_INSTALL) $(TOOLCHAIN_GCC-CROSS_INSTALL)

#clean = ${clean.gcc-cross.toolchain} ${clean.uclibc.toolchain} ${clean.gcc-static.toolchain} ${clean.binutils.toolchain} ${clean.mpfr.toolchain} ${clean.gmp.toolchain}

.PHONY: toolchain-distclean
${Rule("toolchain-distclean")}
	-$(RM) -Rf $(TOOLCHAIN_BUILD_DIR) $(TOOLCHAIN_ROOT_DIR)
	
DISTCLEAN_TARGETS += toolchain-distclean
	
.NOTPARALLEL: