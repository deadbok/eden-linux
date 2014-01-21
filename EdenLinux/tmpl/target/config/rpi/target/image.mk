#mtl
${local_namespace("target.image")}

${Rule("$(IMAGES_DIR)/$(TARGET_IMAGE_FILENAME)", rule_var_name= var_name("file"))}
	$(DD) if=/dev/zero of=$(TARGET_IMAGE_FILE) bs=1M count=$(IMAGE_SIZE)

#Calculate the root partition size with a 100m b
${local()}ROOT_SIZE := $(shell echo $(IMAGE_SIZE)\-$(TARGET_IMAGE_BOOT_SIZE) | bc)

#Get a free loop device
ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

${Rule('$(TEMP_DIR)/.fs', '$(TARGET_IMAGE_FILE)', rule_var_name= var_name('filesystem'))}
	#Create an msdos partition table
	parted -s $(TARGET_IMAGE_FILE) mklabel msdos
	#Create a FAT boot partition
	parted -s $(TARGET_IMAGE_FILE) mkpart primary fat32 1 $(strip $(TARGET_IMAGE_BOOT_SIZE))m
	#Create an ext2 root partition
	parted -s $(TARGET_IMAGE_FILE) mkpart primary ext2  $(strip $(TARGET_IMAGE_BOOT_SIZE))m $(strip $(TARGET_IMAGE_ROOT_SIZE))m
#	parted -s $(TARGET_IMAGE_FILE) set 1 boot on
	losetup $(LOOP_DEVICE) $(TARGET_IMAGE_FILE)
	kpartx -av $(LOOP_DEVICE)
	#Create boot partition filesystem
	mkfs.vfat /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1
	#Create root partition filesystem
	mkfs.ext2 -b 1024 /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p2
	$(TOUCH) $(TEMP_DIR)/.fs

${Rule('$(TEMP_DIR)/.image', '$(TARGET_IMAGE_FILE) $(TARGET_IMAGE_FILESYSTEM)', rule_var_name= var_name('create'))}
	$(TOUCH) $(TEMP_DIR)/.image

#target:
#	image:
#		dir = images
#		filename = root.img
#		size = 256
#		
#		mkdir(${root}/${distbuild_dir}/${dir})
#		{
#			${target}: ${target}/.dir
#			
#				
#			${target}/.dir:
#				$mkdir ${target}
#				$touch ${target}/.dir		
#		}
#		file(${root}/${distbuild_dir}/${dir}/${filename}, ${root}/${distbuild_dir}/${dir}/.dir)
#		{
#			${target}: ${dependencies}
#				dd if=/dev/zero of=${target} bs=1M count=${size}
#		}
#	:image
#:target

.NOTPARALLEL: