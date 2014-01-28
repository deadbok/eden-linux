#mtl
${local_namespace("target")}

#Include image file generation
include target/config/$(TARGET)/target/image.mk
#Include boot service generation
include target/services.mk
#include man page compression
include target/zip-man.mk

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

#ALL that is done here has root permission
${local()}INSTALL += $(TARGET_IMAGE_CREATE)

.PHONY: target-distclean
${Rule("target-distclean", "")}:
	$(MAKE)  $(TARGET_DISTCLEAN_TARGETS)

DISTCLEAN_TARGETS += target-distclean

.NOTPARALLEL: