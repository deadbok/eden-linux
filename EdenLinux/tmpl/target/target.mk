#mtl
${local_namespace("target")}

#Include image file generation
include target/config/$(TARGET)/target/image.mk

${local()}INSTALL += $(PACKAGES_INSTALL) $(TARGET_IMAGE_CREATE)

.PHONY: target-distclean
target-distclean:
	-$(RM) -fR $(STRIPPED_ROOTFS_DIR)
	$(MAKE)  $(TARGET_DISTCLEAN_TARGETS)

DISTCLEAN_TARGETS += target-distclean

.NOTPARALLEL: