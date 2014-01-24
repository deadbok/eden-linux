#mtl
${local_namespace("target.image")}

#Get a free loop device
ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

BOOT_MOUNT_PATH = $(TEMP_DIR)/boot
ROOT_MOUNT_PATH = $(TEMP_DIR)/root 

${Rule("$(IMAGES_DIR)/$(TARGET_IMAGE_FILENAME)", rule_var_name= var_name("file"))}
	$(DD) if=/dev/zero of=$(TARGET_IMAGE_FILE) bs=1M count=$(IMAGE_SIZE)

#Calculate the root partition size 
${local()}ROOT_SIZE := $(shell echo $(IMAGE_SIZE)\-$(TARGET_IMAGE_BOOT_SIZE) | bc)

${Rule('$(TEMP_DIR)/.fs', '$(TARGET_IMAGE_FILE)', rule_var_name= var_name('filesystem'))}
	#Create an msdos partition table
	$(PARTED) -s $(TARGET_IMAGE_FILE) mklabel msdos
	#Create a FAT boot partition
	$(PARTED) -s $(TARGET_IMAGE_FILE) unit cyl mkpart primary fat32 -- 1 $(strip $(TARGET_IMAGE_BOOT_SIZE))m
	#Set boot flag
	$(PARTED) -s $(TARGET_IMAGE_FILE) toggle 1 boot
	#Create an ext4 root partition
	$(PARTED) -s $(TARGET_IMAGE_FILE) mkpart primary ext4  -- $(strip $(TARGET_IMAGE_BOOT_SIZE))m $(strip $(TARGET_IMAGE_ROOT_SIZE))m
ifdef VERBOSE
	$(PARTED) -s $(TARGET_IMAGE_FILE) print all
endif
	$(LOSETUP) $(LOOP_DEVICE) $(TARGET_IMAGE_FILE)
	$(KPARTX) -av $(LOOP_DEVICE)
	#Create boot partition FAT32 filesystem
	$(MKFS_VFAT) /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1
	#Create root partition filesystem
	$(MKFS_EXT4) /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p2
	#Remove loop device
	$(KPARTX) -d $(LOOP_DEVICE)
	$(LOSETUP) -d $(LOOP_DEVICE)
	$(TOUCH) $(TEMP_DIR)/.fs
	
${Rule('$(TEMP_DIR)/.fs-copy', '$(TARGET_IMAGE_FILESYSTEM)', rule_var_name= var_name('copy'))}
	#Create a loop device for the disk image
	$(LOSETUP) $(LOOP_DEVICE) $(TARGET_IMAGE_FILE)
	$(KPARTX) -av $(LOOP_DEVICE)
	#Mount boot partition
	$(MKDIR) $(BOOT_MOUNT_PATH)
	$(MOUNT) /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1 $(BOOT_MOUNT_PATH)
	#Copy boot files
	$(CP) -R $(ROOTFS_DIR)/boot/* $(BOOT_MOUNT_PATH)
	#Unmount boot partition
	$(UMOUNT) $(BOOT_MOUNT_PATH)
	#Mount root partition
	$(MKDIR) $(ROOT_MOUNT_PATH)
	$(MOUNT) /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p2 $(ROOT_MOUNT_PATH)
	#Copy everything but the boot files
	$(RSYNC) -aD --exclude=$(ROOTFS_DIR)/boot $(ROOTFS_DIR)/* $(ROOT_MOUNT_PATH)
	#Take a break, wait for delayd writes
	sleep 5
	#Unmount root partition
	$(UMOUNT) $(ROOT_MOUNT_PATH)
	#Remove loop device
	$(KPARTX) -d $(LOOP_DEVICE)
	$(LOSETUP) -d $(LOOP_DEVICE)
	$(TOUCH) $(TEMP_DIR)/.fs-copy

${Rule('$(TEMP_DIR)/.image', '$(TARGET_IMAGE_COPY)', rule_var_name= var_name('create'))}
	$(TOUCH) $(TEMP_DIR)/.image

.NOTPARALLEL: