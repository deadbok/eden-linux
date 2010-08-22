#make[1]: Leaving directory `/home/oblivion/src/EdenLinux/toolchain-build-i686/syslinux-4.02'
#cp  /home/oblivion/src/EdenLinux/packages/syslinux/extlinux.conf /home/oblivion/src/EdenLinux/rootfs/boot/extlinux.conf
#mkdir -p /home/oblivion/src/EdenLinux/rootfs/dev/pts
#chown root:root /home/oblivion/src/EdenLinux/rootfs/dev/pts
#mkdir -p /home/oblivion/src/EdenLinux/rootfs/dev
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/zero c 1 5
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/null c 1 3
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/tty c 5 0
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/console c 5 1
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/ptmx c 5 2
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/tty0 c 4 0
#mknod /home/oblivion/src/EdenLinux/rootfs/dev/tty1 c 4 1
#touch /home/oblivion/src/EdenLinux/rootfs/dev/*
#make: Circular ext2 <- ext2 dependency dropped.
LOOP_DEVICE := $(shell losetup -f)

ext2: $(EDEN_IMAGE_FILE)
	parted -s $(EDEN_IMAGE_FILE) mklabel msdos
	parted -s $(EDEN_IMAGE_FILE) mkpart primary ext2 0 120m
	parted -s $(EDEN_IMAGE_FILE) set 1 boot on
	losetup $(LOOP_DEVICE) $(EDEN_IMAGE_FILE)	
	kpartx -av $(LOOP_DEVICE) 		
	mke2fs -b 1024 /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1
	mount /dev/mapper/$(subst /dev/,,$(LOOP_DEVICE))p1 $(TEMP_DIR)
	cp  -dpR $(ROOTFS)/linuxrc  $(TEMP_DIR)/linuxrc
	cp  -dpR $(ROOTFS)/bin $(TEMP_DIR)
	cp  -dpR $(ROOTFS)/boot $(TEMP_DIR)
	cp  -dpR $(ROOTFS)/dev $(TEMP_DIR)
	cp  -dpR $(ROOTFS)/etc $(TEMP_DIR)
	cp  -dpR  $(ROOTFS)/lib $(TEMP_DIR)
	cp  -dpR  $(ROOTFS)/proc $(TEMP_DIR)
	cp  -dpR  $(ROOTFS)/sbin $(TEMP_DIR)
	cp  -dpR  $(ROOTFS)/sys $(TEMP_DIR)
	cp  -dpR  $(ROOTFS)/usr $(TEMP_DIR)
	cp  -dpR  $(ROOTFS)/var $(TEMP_DIR)
	cp  -dpR $(ROOTFS)/root $(TEMP_DIR)
	chown root:root -R  $(TEMP_DIR)/*
	$(TOOLCHAIN_BUILD_DIR)/syslinux-$(SYSLINUX_VERSION)/extlinux/extlinux --sectors=63 --heads=16 --install $(TEMP_DIR)/boot
	umount $(TEMP_DIR)
	kpartx -d $(LOOP_DEVICE)
	losetup -d $(LOOP_DEVICE)
	
