#mtl
${local_namespace("packages")}

${local}FILE_DIR = /packages
${local}BUILD_DIR = $(BUILD_DIR)/packages_$(ARCH)_build

#For some reason, the kernel build seems to wipe out /usr/include, which means that all uClibc
#header files are missing. To make sure these are installed again, an else uneeded dependency
#is added here "${install.uclibc.toolchain}", to make sure the headers are installed if missing 	
#install = ${install.fsh.packages} ${copy.syslinux.packages} ${install.e2fsprogs.packages} ${install.linux-kernel.packages} ${install.baseconf.packages} ${install.busybox.packages} ${install.bootscripts.packages} ${install.udev.packages} ${install.dropbear.packages} ${install.iana-etc.packages} ${install.bootdevs.packages} ${install.nano.packages} ${install.python.packages} 
#build = ${install.toolchain} ${build_dir.packages}/.dir ${build.linux-kernel.packages} ${build.busybox.packages} ${build.e2fsprogs.packages} ${build.udev.packages} ${build.nano.packages} ${build.dropbear.packages} ${build.iana-etc.packages} ${build.python.packages}

$(PACKAGES_BUILD_DIR):
	$(MKDIR) $(PACKAGES_BUILD_DIR)
	
${local}ENV = $(TOOLCHAIN_ENV) PKG_CONFIG_LIBDIR=$(ROOTFS_DIR)/usr/lib/pkg-config

SERVICES := ""

include packages/kernel.mk
include packages/e2fsprogs.mk
include packages/iana-etc.mk
include packages/bootdevs.mk
include packages/zlib.mk
include packages/ncurses.mk
include packages/baseconf.mk
include packages/nano.mk
include packages/dropbear.mk
include packages/udev.mk
include packages/python.mk

${local}BUILD := $(TOOLCHAIN_INSTALL) $(PACKAGES_BUILD_DIR) $(PACKAGES_KERNEL_BUILD) $(PACKAGES_BUSYBOX_ALL) $(PACKAGES_E2FSPROGS_INSTALL) $(PACKAGES_E2FSPROGS_INSTALL-LIBS) $(PACKAGES_IANA-ETC_ALL) $(PACKAGES_ZLIB_INSTALL) $(PACKAGES_NCURSES_INSTALL) $(PACKAGES_NANO_INSTALL) $(PACKAGES_DROPBEAR_ALL) $(PACKAGES_UDEV_ALL) $(PACKAGES_PYTHON_INSTALL)

${local}INSTALL := $(PACKAGES_KERNEL_INSTALL) $(PACKAGES_BUSYBOX_INSTALL) $(PACKAGES_IANA-ETC_INSTALL) $(PACKAGES_BOOTDEVS_INSTALL) $(PACKAGES_BASECONF_INSTALL) $(PACKAGES_DROPBEAR_INSTALL) $(PACKAGES_BOOTSCRIPTS_INSTALL) $(PACKAGES_UDEV_DEVICES) $(PACKAGES_UDEV_INSTALL)