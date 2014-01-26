##mtl
${local_namespace("target.ext2")}

ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

ext2: $(TOOLCHAIN_SYSLINUX_BUILD) $(TARGET_IMAGE_FILE)
ifeq ($(UID), 0)
	parted -s $(TARGET_IMAGE_FILE) mklabel msdos
	parted -s $(TARGET_IMAGE_FILE) mkpart primary ext2 1 250m
	parted -s $(TARGET_IMAGE_FILE) set 1 boot on
	losetup $(LOOP_DEVICE) $(TARGET_IMAGE_FILE)
	kpartx -av $(LOOP_DEVICE) 		
	mke2fs -b 1024 /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1
	mount /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1 $(TEMP_DIR)
	cp  -dpR $(ROOTFS_DIR)/linuxrc  $(TEMP_DIR)/linuxrc
	cp  -dpR $(ROOTFS_DIR)/bin $(TEMP_DIR)
	cp  -dpR $(ROOTFS_DIR)/boot $(TEMP_DIR)
	cp  -dpR $(ROOTFS_DIR)/dev $(TEMP_DIR)
	cp  -dpR $(ROOTFS_DIR)/etc $(TEMP_DIR)
	cp  -dpR  $(ROOTFS_DIR)/lib $(TEMP_DIR)
	cp  -dpR  $(ROOTFS_DIR)/proc $(TEMP_DIR)
	cp  -dpR  $(ROOTFS_DIR)/sbin $(TEMP_DIR)
	cp  -dpR  $(ROOTFS_DIR)/sys $(TEMP_DIR)
	cp  -dpR  $(ROOTFS_DIR)/usr $(TEMP_DIR)
	cp  -dpR  $(ROOTFS_DIR)/var $(TEMP_DIR)
	cp  -dpR $(ROOTFS_DIR)/root $(TEMP_DIR)
	chown root:root -R  $(TEMP_DIR)/*
	$(TOOLCHAIN_SYSLINUX_BUILD_DIR)/extlinux/extlinux --sectors=63 --heads=16 --install $(TEMP_DIR)/boot
	umount $(TEMP_DIR)
	kpartx -d $(LOOP_DEVICE)
	losetup -d $(LOOP_DEVICE)
	chmod a+rw $(TARGET_IMAGE_FILE)			
else
	$(error you need to be root)
endif

		
		
#target:
#	ext2:
#		build(ext2, ${build.syslinux.toolchain} ${file.image.target} $(TEMP_DIR)/.dir)
#		{
#			ifeq (${uid}, 0)
#			LOOP_DEVICE = $(shell losetup -f)
#			endif
#
#			ext2: ${dependencies}
#			ifeq (${uid}, 0)
#				parted -s ${file.image.target} mklabel msdos
#				parted -s ${file.image.target} mkpart primary ext2 1 250m
#				parted -s ${file.image.target} set 1 boot on
#				losetup $(LOOP_DEVICE) ${file.image.target}	
#				kpartx -av $(LOOP_DEVICE) 		
#				mke2fs -b 1024 /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1
#				mount /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1 ${root}/$(TEMP_DIR)
#				cp  -dpR $(ROOTFS_DIR)/linuxrc  $(TEMP_DIR)/linuxrc
#				cp  -dpR $(ROOTFS_DIR)/bin $(TEMP_DIR)
#				cp  -dpR $(ROOTFS_DIR)/boot $(TEMP_DIR)
#				cp  -dpR $(ROOTFS_DIR)/dev $(TEMP_DIR)
#				cp  -dpR $(ROOTFS_DIR)/etc $(TEMP_DIR)
#				cp  -dpR  $(ROOTFS_DIR)/lib $(TEMP_DIR)
#				cp  -dpR  $(ROOTFS_DIR)/proc $(TEMP_DIR)
#				cp  -dpR  $(ROOTFS_DIR)/sbin $(TEMP_DIR)
#				cp  -dpR  $(ROOTFS_DIR)/sys $(TEMP_DIR)
#				cp  -dpR  $(ROOTFS_DIR)/usr $(TEMP_DIR)
#				cp  -dpR  $(ROOTFS_DIR)/var $(TEMP_DIR)
#				cp  -dpR $(ROOTFS_DIR)/root $(TEMP_DIR)
#				chown root:root -R  $(TEMP_DIR)/*
#				${build_dir.toolchain}/syslinux-${version.syslinux.toolchain}/extlinux/extlinux --sectors=63 --heads=16 --install $(TEMP_DIR)/boot
#				umount $(TEMP_DIR)
#				kpartx -d $(LOOP_DEVICE)
#				losetup -d $(LOOP_DEVICE)
#				chmod a+rw ${file.image.target}			
#			else
#				$(error you need to be root)
#			endif
#		}
#	:ext2
#:target

.NOTPARALLEL: