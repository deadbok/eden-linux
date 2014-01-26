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

${Rule('$(TEMP_DIR)/.fs', '$(TARGET_IMAGE_FILE)', rule_var_name= var_name('filesystem'))}
	#Create an msdos partition table
	$(PARTED) -s $(TARGET_IMAGE_FILE) mklabel msdos
	#Create an ext4 root partition
	$(PARTED) -s $(TARGET_IMAGE_FILE) mkpart primary ext4  -- 1s $(strip $(IMAGE_SIZE))m
	#Set boot flag
	$(PARTED) -s $(TARGET_IMAGE_FILE) toggle 1 boot	
ifdef VERBOSE
	$(PARTED) -s $(TARGET_IMAGE_FILE) print all
endif
	$(LOSETUP) $(LOOP_DEVICE) $(TARGET_IMAGE_FILE)
	$(KPARTX) -av $(LOOP_DEVICE)
	#Create root partition filesystem
	$(MKFS_EXT4) /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1
	#Remove loop device
	$(KPARTX) -d $(LOOP_DEVICE)
	$(LOSETUP) -d $(LOOP_DEVICE)
	$(TOUCH) $(TEMP_DIR)/.fs
	
${Rule('$(TEMP_DIR)/.fs-copy', '$(TARGET_IMAGE_FILESYSTEM)', rule_var_name= var_name('copy'))}
	#Create a loop device for the disk image
	$(LOSETUP) $(LOOP_DEVICE) $(TARGET_IMAGE_FILE)
	$(KPARTX) -av $(LOOP_DEVICE)
	#Mount root partition
	$(MKDIR) $(ROOT_MOUNT_PATH)
	$(MOUNT) /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1 $(ROOT_MOUNT_PATH)
	#Copy everything but the boot files
	$(RSYNC) -aD $(IMAGE_ROOTFS_DIR)/* $(ROOT_MOUNT_PATH)
	#Make everything owned by root
	$(CHOWN) -R root:root $(strip $(ROOT_MOUNT_PATH))/*
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

.PHONY: image_clean
${Rule('image_clean', '')}
	-$(RM) $(TARGET_IMAGE_FILE)
	
DISTLEAN_TARGETS += image_clean

.NOTPARALLEL: