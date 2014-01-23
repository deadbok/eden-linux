#mtl
${local_namespace("packages")}

${local()}FILE_DIR = /packages
${local()}BUILD_DIR = $(BUILD_DIR)/packages_$(ARCH)_build

#For some reason, the kernel build seems to wipe out /usr/include, which means that all uClibc
#header files are missing. To make sure these are installed again, an else uneeded dependency
#is added here "${install.uclibc.toolchain}", to make sure the headers are installed if missing 	
#install = ${install.fsh.packages} ${copy.syslinux.packages} ${install.e2fsprogs.packages} ${install.linux-kernel.packages} ${install.baseconf.packages} ${install.busybox.packages} ${install.bootscripts.packages} ${install.udev.packages} ${install.dropbear.packages} ${install.iana-etc.packages} ${install.bootdevs.packages} ${install.nano.packages} ${install.python.packages} 
#build = ${install.toolchain} ${build_dir.packages}/.dir ${build.linux-kernel.packages} ${build.busybox.packages} ${build.e2fsprogs.packages} ${build.udev.packages} ${build.nano.packages} ${build.dropbear.packages} ${build.iana-etc.packages} ${build.python.packages}

$(PACKAGES_BUILD_DIR):
	$(MKDIR) $(PACKAGES_BUILD_DIR)
	
${local()}ENV = PATH=$(TOOLCHAIN_PATH) $(TOOLCHAIN_CMDS) CFLAGS=$(TARGET_CFLAGS) CXXFLAGS=$(TARGET_CXXFLAGS) LDFLAGS=$(TARGET_LDFLAGS) PKG_CONFIG_LIBDIR=$(ROOTFS_DIR)/usr/lib/pkg-config

SERVICES := 

#WARNING: These are ordered according to dependencies
include packages/openrc.mk
include packages/bootscripts.mk
include packages/busybox.mk
include packages/bootdevs.mk
include packages/baseconf.mk
include packages/iana-etc.mk
include packages/ncurses.mk
include packages/nano.mk

#include packages/e2fsprogs.mk
#include packages/zlib.mk
#include packages/dropbear.mk
#include packages/udev.mk

#include board specific packages
include target/config/$(TARGET)/packages/*.mk

#Build toolchain, FSH dir structure, base packages, board specific packages
${local()}BUILD := packages-build 
.PHONY: $(${local()}BUILD)
$(${local()}BUILD): $(TOOLCHAIN_INSTALL) $(TARGET_FSH_INSTALL) $(PACKAGES_BUILD_DIR) $(PACKAGES_BUILD_TARGETS) $(PACKAGES_BOARD_BUILD) 


${local()}INSTALL := $(PACKAGES_BUILD_DIR)/.installed
$(${local()}INSTALL): $(PACKAGES_BOARD_INSTALL) $(PACKAGES_KERNEL_INSTALL) $(PACKAGES_INSTALL_TARGETS)
	$(TOUCH) $(PACKAGES_BUILD_DIR)/.installed

#Temporarily stop make from building any packages
#${local()}BUILD :=
#${local()}INSTALL :=

.PHONY: packages-distclean
packages-distclean:
	-$(RM) -Rf $(PACKAGES_BUILD_DIR)
	
DISTCLEAN_TARGETS += packages-distclean

.NOTPARALLEL: