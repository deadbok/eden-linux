#mtl
${local_namespace("target")}

#Include image file generation
include target/config/$(TARGET)/target/image.mk
#Include boot service generation
include target/services.mk
#include man page compression
include target/zip-man.mk
#include binary stripping
include target/strip.mk

ifdef TARGET_REMOVE_FILES
#Get list of files to remove from image root
${local()}REMOVE_LIST := $(shell cat $(TARGET_REMOVE_FILES))
endif

#Copy root filesystem to image dir
.PHONY: copy-root
${Rule("copy-root")}:
	#Copy root files
	$(RSYNC) -aD --delete $(ROOTFS_DIR)/* $(IMAGE_ROOTFS_DIR)/ 
	#Remove files from the list
	-$(RM) -R $(addprefix $(IMAGE_ROOTFS_DIR)/,$(TARGET_REMOVE_LIST))
	#Compress man pages if asked
ifeq ($(COMPRESS_MAN_PAGES),1)
	$(MAKE) zip-man
endif
ifeq ($(STRIP_TARGET),1)
	$(MAKE) strip-all
endif

.PHONY: img-perm
${Rule('img-perm')}: $(TARGET_IMAGE_CREATE)
	$(CHMOD) a+rw $(TARGET_IMAGE_FILE)

#ALL that is done here has root permission
${local()}INSTALL += $(TARGET_IMAGE_CREATE) img-perm

.PHONY: target-distclean
${Rule("target-distclean", "")}:
	-$(RM) -Rf $(IMAGE_ROOTFS_DIR)

DISTCLEAN_TARGETS += target-distclean

.NOTPARALLEL: