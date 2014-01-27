#mtl
${local_namespace("toolchain")}
#Toolchain names
${local()}CC := $(ARCH_TARGET)-gcc
${local()}CXX := $(ARCH_TARGET)-g++
#${local()}GO := $(ARCH_TARGET)-gccgo
${local()}AR := $(ARCH_TARGET)-ar
${local()}AS := $(ARCH_TARGET)-as
${local()}LD := $(ARCH_TARGET)-ld
#${local()}GOLD := $(ARCH_TARGET)-ld.gold
${local()}RANLIB := $(ARCH_TARGET)-ranlib
${local()}READELF := $(ARCH_TARGET)-readelf
${local()}STRIP := $(ARCH_TARGET)-strip


${local()}CFLAGS := "-O2"
${local()}CXXFLAGS := "-O2"

ifdef DEBUG
${local()}CFLAGS := "-g"
${local()}CXXFLAGS := "-g"
endif

${local()}FILE_DIR := $(ROOT)/toolchain
${local()}BUILD_DIR := $(BUILD_DIR)/toolchain_$(ARCH)_build
${local()}ROOT_DIR := $(BUILD_DIR)/toolchain_$(ARCH)

${local()}PATH := $(TOOLCHAIN_ROOT_DIR)/bin:$(TOOLCHAIN_ROOT_DIR)/gcc-static/bin:$(PATH)
${local()}FLAGS := CFLAGS=$(TOOLCHAIN_CFLAGS) CXXFLAGS=$(TOOLCHAIN_CXXFLAGS)
${local()}CMDS := CC="$(TOOLCHAIN_CC) -I $(TOOLCHAIN_ROOT_DIR)/usr/include" CXX="$(TOOLCHAIN_CXX) -I $(TOOLCHAIN_ROOT_DIR)/usr/include" GO="$(TOOLCHAIN_GO)" AR="$(TOOLCHAIN_AR)" LD="$(TOOLCHAIN_CC)" RANLIB="$(TOOLCHAIN_RANLIB)" READELF="$(TOOLCHAIN_READELF)" STRIP="$(TOOLCHAIN_STRIP)"
#Environtment for calling the toolchain
${local()}ENV := $(TOOLCHAIN_CMDS) PATH=$(TOOLCHAIN_PATH) $(TOOLCHAIN_FLAGS)


#Take care of ARCH specific flags for gcc
#ARM
ifeq ($(ARCH),arm)
	GCC_EXTRA_CONFIG := --with-float=$(FLOAT_SUPPORT) --with-fpu=$(FPU_VER) --with-arch=$(CPU_ARCH)
else
	GCC_EXTRA_CONFIG :=
endif 

$(TOOLCHAIN_BUILD_DIR):
	$(MKDIR) $(TOOLCHAIN_BUILD_DIR)

include toolchain/gcc-cross.mk
include target/fsh.mk

${local()}INSTALL := $(TOOLCHAIN_BUILD_DIR) $(TARGET_FSH_INSTALL) \
					 $(TOOLCHAIN_KERNEL-HEADERS_INSTALL) \
					 $(TOOLCHAIN_UCLIBC_INSTALL) \
					 $(TOOLCHAIN_GCC-CROSS_INSTALL) \
					 $(TOOLCHAIN_UCLIBC_INSTALL)

.PHONY: toolchain-distclean
${Rule("toolchain-distclean")}
	-$(RM) -R $(TOOLCHAIN_BUILD_DIR) $(TOOLCHAIN_ROOT_DIR)
	
DISTCLEAN_TARGETS += toolchain-distclean
	
.NOTPARALLEL: