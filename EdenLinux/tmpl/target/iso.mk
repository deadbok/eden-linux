#mtl
${local_namespace("target.iso")}

${local}DIR = $(BUILD_DIR)/images
${local}FILE := $(TARGET_ISO_DIR)/eden.iso

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

$(TARGET_ISO_FILE): $(TOOLCHAIN_SYSLINUX_SRC_DIR)/core/isolinux.bin $(TARGET_ISO_ISOLINUX_CONFIG) $(PACKAGES_SYSLINUX_ISOLINUX_CONFIG) $(TARGET_INITRAMFS_CREATE) $(PACKAGES_KERNEL_INSTALL)
ifeq ($(UID), 0)
	$(CP) $(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION) $(ROOTFS_DIR)/boot/kernel
	$(CP) $(TOOLCHAIN_SYSLINUX_BUILD_DIR)/core/isolinux.bin $(ROOTFS_DIR)/boot/isolinux/
	$(TOUCH)  $(ROOTFS_DIR)/etc/EdenLive
	$(GENISOIMAGE) -o $(TARGET_ISO_FILE) -R -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table $(ROOTFS_DIR)	
else
	$(error you need to be root)
endif


#target:
#	iso:
#		dir = images
#	
#		isolinux_config(${root}/${rootfs_dir}/boot/isolinux/isolinux.cfg, ${isolinux_config.syslinux.packages})
#		{
#			${target}: ${dependencies}
#				mkdir -p ${rootfs_dir}/boot/isolinux/
#				cp ${isolinux_config.syslinux.packages} ${root}/${rootfs_dir}/boot/isolinux/
#		}
#		
#		build(${root}/${distbuild_dir}/${dir}/image.iso, ${build.syslinux.toolchain} ${isolinux_config} ${create.initramfs.target} ${mkdir.image.target} ${install.linux-kernel.packages})
#		{
#			ifeq (${uid}, 0)
#			LOOP_DEVICE = $(shell losetup -f)
#			endif
#
#			${target}: ${dependencies}
#			ifeq (${uid}, 0)
#				cp ${rootfs_dir}/boot/kernel-${version.linux-kernel.packages} ${rootfs_dir}/boot/kernel
#				cp ${build_dir.toolchain}/syslinux-${version.syslinux.toolchain}/core/isolinux.bin ${rootfs_dir}/boot/isolinux/
#				touch  ${rootfs_dir}/etc/EdenLive
#				genisoimage -o ${target} -R -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table ${rootfs_dir}	
#			else
#				$(error you need to be root)
#			endif
#		}
#	:iso
#:target