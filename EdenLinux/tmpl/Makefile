#mtl

include colors.mk
include config.mk
include functions.mk

#Get the userid
UID := $(shell id -u)

SERVICES :=
	
$(DOWNLOAD_DIR):
	$(MKDIR) $(DOWNLOAD_DIR)
	
$(IMAGES_DIR):
	$(MKDIR) $(IMAGES_DIR)
	
$(ROOTFS_DIR):
	$(MKDIR) $(ROOTFS_DIR)

$(STRIPPED_ROOTFS_DIR): $(TEMP_DIR) $(TEMP_DIR)/.stripped_rootfs_dir

$(TEMP_DIR)/.stripped_rootfs_dir:
	$(MKDIR) $(STRIPPED_ROOTFS_DIR)
	$(TOUCH) $@

$(TEMP_DIR):
	$(MKDIR) $(TEMP_DIR)

include commands.mk

include toolchain/toolchain.mk
include packages/packages.mk
include target/target.mk

#Print out info about the build
.PHONY: build-info
${Rule("build-info", "")}:
	@$(ECHO) " - Target: $(TARGET)"
	@$(ECHO) " - Arch: $(ARCH)"
	@$(ECHO) " - Kernel arch: $(KERNEL_ARCH)" 
	@$(ECHO) " - Target triple $(ARCH_TARGET)" 
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
	
.PHONY: all
all: build-info $(DOWNLOAD_DIR) $(IMAGES_DIR) $(ROOTFS_DIR) $(TEMP_DIR) $(TOOLCHAIN_INSTALL) $(PACKAGES_BUILD)
	$(TOUCH) $(TEMP_DIR)/.all

#Cry out if trying install before all
$(TEMP_DIR)/.all:
	$(error Make target 'all' first)

INSTALL := $(PACKAGES_INSTALL) $(TARGET_INSTALL)

.PHONY: install
install: build-info $(TEMP_DIR)/.all 
ifeq ($(UID), 0)
	$(MAKE) $(INSTALL)
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
