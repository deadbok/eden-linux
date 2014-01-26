##mtl
${local_namespace("target.iso")}

${local()}DIR = $(BUILD_DIR)/images
${local()}FILE := $(TARGET_ISO_DIR)/eden.iso


.PHONY: TARGET_ISO_FSTAB
${Rule('$(TARGET_ROOTFS_DIR)/etc/fstab', '$(ROOT)/target/iso/fstab', rule_var_name=var_name("fstab"))}
	$(CP) $(ROOT)/${namespace.current.replace(".", "/")}/fstab $(TARGET_ROOTFS_DIR)/etc/fstab

include packages/syslinux.mk 

TARGET_ISO_ISOLINUX_CONFIG := $(TARGET_ROOTFS_DIR)/boot/isolinux/isolinux.cfg
$(TARGET_ISO_ISOLINUX_CONFIG): $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG)
	$(MKDIR) $(TARGET_ROOTFS_DIR)/boot/isolinux/
	$(CP) $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG) $(TARGET_ROOTFS_DIR)/boot/isolinux/

ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

include target/initramfs.mk
include toolchain/syslinux.mk

$(TARGET_ISO_FILE): $(PACKAGES_INSTALL) $(TOOLCHAIN_SYSLINUX_SRC_DIR)/core/isolinux.bin $(TARGET_ISO_ISOLINUX_CONFIG) $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG) $(TARGET_INITRAMFS_CREATE) $(PACKAGES_KERNEL_INSTALL) $(TARGET_ISO_FSTAB)
ifeq ($(UID), 0)
	$(CP) $(TARGET_ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION) $(TARGET_ROOTFS_DIR)/boot/kernel
	$(CP) $(TOOLCHAIN_SYSLINUX_BUILD_DIR)/core/isolinux.bin $(TARGET_ROOTFS_DIR)/boot/isolinux/
	$(TOUCH)  $(TOOLCHAIN_SYSLINUX_BUILD_DIR)/core/isolinux.bin
	$(TOUCH)  $(TARGET_ROOTFS_DIR)/etc/EdenLive
	$(MKDIR) $(TARGET_ISO_DIR)
	$(GENISOIMAGE) -o $(TARGET_ISO_FILE) -R -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table $(TARGET_ROOTFS_DIR)	
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