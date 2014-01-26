#mtl
#This is the root Makefile to be invoked when using the EdenLinux build system.
#There a to targets of importance when building. They are:
#
#    all:       This will build everything and install it to $(ROOTFS_DIR) using
#			    fakeroot.
#
#    install:	Install everything on the final image file. Needs root
#				permisssions.

 
#Include color definitions
include colors.mk
#Include config/profile values
include config.mk
#Include utility functions
include functions.mk

#Get the userid
UID := $(shell id -u)

#Services need at boot
SERVICES :=

#Create download directory
$(DOWNLOAD_DIR):
	$(MKDIR) $(DOWNLOAD_DIR)

#Create directory for the final images	
$(IMAGES_DIR):
	$(MKDIR) $(IMAGES_DIR)

#Create directory for the full root filesystem
$(ROOTFS_DIR):
	$(MKDIR) $(ROOTFS_DIR)

#$(STRIPPED_ROOTFS_DIR): $(TEMP_DIR) $(TEMP_DIR)/.stripped_rootfs_dir

#$(TEMP_DIR)/.stripped_rootfs_dir:
#	$(MKDIR) $(STRIPPED_ROOTFS_DIR)
#	$(TOUCH) $@

#Create directory for temporary files
$(TEMP_DIR):
	$(MKDIR) $(TEMP_DIR)

#Include commands used by the buildsystem
include commands.mk

#Include everything needed for the toolchain
include toolchain/toolchain.mk
#Include packages to compile with the toolchain
include packages/packages.mk
#Include target specific operations and packages
include target/target.mk

#Print out info about the build
.PHONY: build-info
${Rule("build-info", "")}:
	@$(ECHO) " - Target: $(TARGET)"
	@$(ECHO) " - Arch: $(ARCH)"
	@$(ECHO) " - Kernel arch: $(KERNEL_ARCH)" 
	@$(ECHO) " - Target triple: $(ARCH_TARGET)" 
	@$(ECHO) " - Host: $(HOST)"
	@$(ECHO) " - ABI: $(ABI)"
	@$(ECHO) 
	@$(ECHO) " - Image size: $(IMAGE_SIZE)mb"
	@$(ECHO) " - Image file name: $(TARGET_IMAGE_FILENAME)"
	@$(ECHO)
	@$(ECHO) " - Base packages: $(PACKAGES_NAME_TARGETS)"
	@$(ECHO) " - Board specific packages: $(PACKAGES_NAME_BOARD)"
	@$(ECHO) "-----------------------------------------------------------------------------"
	@$(ECHO)

#Build and install everything to $(ROOTFS_DIR)
.PHONY: all
all: build-info $(DOWNLOAD_DIR) $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR) $(TOOLCHAIN_INSTALL) $(TARGET_FSH_INSTALL) $(PACKAGES_INSTALL) $(TARGET_SERVICES_INSTALL) copy-root
	$(TOUCH) $(TEMP_DIR)/.all

#Cry out if trying install before all
$(TEMP_DIR)/.all:
	$(error Make target 'all' first)

#Install to the target image. Root priviledges expected.
.PHONY: install
install: build-info $(TEMP_DIR)/.all 
ifeq ($(UID), 0)
	$(MAKE) $(TARGET_INSTALL)
else
	$(error You need to be root)
endif

.PHONY: clean
clean: $(CLEAN_TARGETS) toolchain-distclean
	-$(RM) -Rf $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR)

.PHONY: distclean
${Rule("distclean", "")}
	-$(RM) -Rf $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR)
	$(MAKE) $(DISTCLEAN_TARGETS)

.NOTPARALLEL:

#TODO: Clean rules
#clean(clean, ${clean.toolchain})
#{
#    ${target}: ${dependencies}
#}
