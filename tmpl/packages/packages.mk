#mtl
${local_namespace("packages")}

${local()}FILE_DIR = $(ROOT)/packages
${local()}BUILD_DIR = $(BUILD_DIR)/packages_$(ARCH)_build

${local()}LDFLAGS = "-Wl,-rpath,$(ROOTFS_DIR)/lib:$(ROOTFS_DIR)/usr/lib"

$(PACKAGES_BUILD_DIR):
	$(MKDIR) $(PACKAGES_BUILD_DIR)
	
${local()}ENV = PATH=$(TOOLCHAIN_PATH) $(TOOLCHAIN_CMDS) \
				CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
				LDFLAGS="$(TARGET_LDFLAGS) $(PACKAGES_LDFLAGS)"\
				PKG_CONFIG_LIBDIR="$(ROOTFS_DIR)/usr/lib/pkgconfig" \
				PKG_CONFIG_DIR="" \
				PKG_CONFIG_SYSROOT_DIR="$(ROOTFS_DIR)"
SERVICES := 

#include base system
include packages/base.mk

#include generated list of packages
include packages/pkg-list.mk
 
#include board specific packages
include target/config/$(TARGET)/packages/*.mk

#Build toolchain, FSH dir structure, base packages, board specific packages
${local()}INSTALL := $(PACKAGES_BUILD_DIR)/.installed 
$(${local()}INSTALL): $(PACKAGES_BUILD_DIR) $(PACKAGES_KERNEL_INSTALL) $(PACKAGES_INSTALL_TARGETS) $(PACKAGES_BOARD_INSTALL) 
	$(TOUCH) $(PACKAGES_BUILD_DIR)/.installed

.PHONY: packages-distclean
packages-distclean:
	-$(RM) -Rf $(PACKAGES_BUILD_DIR)
	
DISTCLEAN_TARGETS += packages-distclean

.NOTPARALLEL: