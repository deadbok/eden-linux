#mtl
${local_namespace("target")}

#Include image file generation
include target/config/$(TARGET)/target/image.mk
#Include boot service generation
include target/services.mk

#Get real user (not root from sudo)
${local()}USER := $(shell who am i | sed -e 's/ .*//')

#Ugly hack to make sure we do not need root to write to the rootfs
.PHONY: rootfs-perm
${Rule('rootfs-perm', '')}:
	$(CHOWN) -R $(shell id -nu $(TARGET_USER)):$(shell id -gn $(TARGET_USER)) $(ROOTFS_DIR)	

${local()}INSTALL += $(PACKAGES_INSTALL) $(TARGET_SERVICES_INSTALL) rootfs-perm $(TARGET_IMAGE_CREATE)

.PHONY: target-distclean
${Rule("target-distclean", "")}:
	-$(RM) -fR $(STRIPPED_ROOTFS_DIR)
	$(MAKE)  $(TARGET_DISTCLEAN_TARGETS)

DISTCLEAN_TARGETS += target-distclean

.NOTPARALLEL: