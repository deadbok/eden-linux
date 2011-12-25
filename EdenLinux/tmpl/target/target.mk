#mtl
${local_namespace("target")}

#Directory from which the root filesystem is assembled
${local()}ROOTFS_DIR := $(ROOTFS_DIR)

${local()}PRE_INSTALL :=

ifdef STRIP_TARGET
#Set the root to the directory which will contain the stripped version
${local()}ROOTFS_DIR := $(STRIPPED_ROOTFS_DIR)

include target/strip.mk

${local()}INSTALL += $(TARGET_PRE_INSTALL) $(TARGET_STRIP_INSTALL)
endif

include target/iso.mk
include target/services.mk

ifdef COMPRESS_MAN_PAGES
include target/zip-man.mk
endif

ifdef REMOVE_HEADERS
include target/headers.mk
endif

.PHONY: $(TEMP_DIR)/.copy_rootfs
${Rule("$(TEMP_DIR)/.copy_rootfs", dependencies = "$(STRIPPED_ROOTFS_DIR)", rule_var_name= var_name("copy_rootfs"))}
	$(CP) -af $(ROOTFS_DIR)/* $(STRIPPED_ROOTFS_DIR)
	$(TOUCH) $@

ifneq ($(ROOTFS_DIR), $(TARGET_ROOTFS_DIR))
${local()}PRE_INSTALL := $(TARGET_COPY_ROOTFS)
endif

${local()}INSTALL += $(TARGET_PRE_INSTALL) $(PACKAGES_INSTALL) $(TARGET_ZIP-MAN_INSTALL) $(TARGET_HEADERS_REMOVE) $(TARGET_SERVICES_INSTALL) $(TARGET_ISO_FILE)

.PHONY: target-distclean
target-distclean:
	-$(RM) -fR $(STRIPPED_ROOTFS_DIR)
	$(MAKE)  $(TARGET_DISTCLEAN_TARGETS)

DISTCLEAN_TARGETS += target-distclean

.NOTPARALLEL: