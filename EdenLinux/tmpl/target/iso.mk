#mtl
${local_namespace("target.iso")}

${local()}DIR = $(BUILD_DIR)/images
${local()}FILE := $(TARGET_ISO_DIR)/eden.iso

include packages/syslinux.mk 

TARGET_ISO_ISOLINUX_CONFIG := $(ROOTFS_DIR)/boot/isolinux/isolinux.cfg
$(TARGET_ISO_ISOLINUX_CONFIG): $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG)
	$(MKDIR) $(ROOTFS_DIR)/boot/isolinux/
	$(CP) $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG) $(ROOTFS_DIR)/boot/isolinux/

ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

include target/initramfs.mk
include toolchain/syslinux.mk

$(TARGET_ISO_FILE): $(PACKAGES_INSTALL) $(TOOLCHAIN_SYSLINUX_SRC_DIR)/core/isolinux.bin $(TARGET_ISO_ISOLINUX_CONFIG) $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG) $(TARGET_INITRAMFS_CREATE) $(PACKAGES_KERNEL_INSTALL)
ifeq ($(UID), 0)
	$(CP) $(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION) $(ROOTFS_DIR)/boot/kernel
	$(CP) $(TOOLCHAIN_SYSLINUX_BUILD_DIR)/core/isolinux.bin $(ROOTFS_DIR)/boot/isolinux/
	$(TOUCH)  $(TOOLCHAIN_SYSLINUX_BUILD_DIR)/core/isolinux.bin
	$(TOUCH)  $(ROOTFS_DIR)/etc/EdenLive
	$(MKDIR) $(TARGET_ISO_DIR)
	$(GENISOIMAGE) -o $(TARGET_ISO_FILE) -R -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table $(ROOTFS_DIR)	
else
	$(error you need to be root)
endif


.PHONY: target-iso-distclean
target-iso-distclean:
ifeq ($(UID), 0)
	-$(RM) -Rf $(TARGET_ISO_DIR)
else
	$(error you need to be root)
endif

TARGET_DISTCLEAN_TARGETS += target-iso-distclean

.NOTPARALLEL: