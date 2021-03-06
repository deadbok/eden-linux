##mtl
${local_namespace("target.initramfs")}

${local()}DIR := $(BUILD_DIR)/initramfs
${local()}FILENAME := initrd.gz
${local()}BUILD_DIR := $(TARGET_INITRAMFS_DIR)_$(ARCH)_build

TARGET_INITRAMFS_DIRS := $(addprefix $(TARGET_INITRAMFS_DIR)/,bin lib dev etc mnt/root proc sbin sys)
$(TARGET_INITRAMFS_DIRS):
	$(MKDIR) $(TARGET_INITRAMFS_DIR)/{bin,lib,dev,etc,mnt/root,proc,sbin,sys}

${Rule('$(TARGET_INITRAMFS_DIR)/init', dependencies="$(ROOT)/target/initramfs/init", rule_var_name= var_name("init"))}
	$(CP) $(ROOT)/target/initramfs/init $(TARGET_INITRAMFS_DIR)/init
	$(CHMOD) +x $(TARGET_INITRAMFS_DIR)/init

$(TARGET_INITRAMFS_BUILD_DIR): $(TARGET_INITRAMFS_BUILD_DIR)/.dir

$(TARGET_INITRAMFS_BUILD_DIR)/.dir:
	$(MKDIR) $(TARGET_INITRAMFS_BUILD_DIR)
	$(TOUCH) $(TARGET_INITRAMFS_BUILD_DIR)/.dir

	
TARGET_INITRAMFS_BUSYBOX_SRC_DIR := $(TARGET_INITRAMFS_BUILD_DIR)/busybox-$(PACKAGES_BUSYBOX_VERSION)

TARGET_INITRAMFS_BUSYBOX_UNPACK := $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR)/Makefile
$(TARGET_INITRAMFS_BUSYBOX_UNPACK): $(DOWNLOAD_DIR)/$(PACKAGES_BUSYBOX_FILE) $(TARGET_INITRAMFS_BUILD_DIR)/.dir 
ifeq ($(suffix $(PACKAGES_BUSYBOX_FILE)), .bz2)
	$(TAR) -xjf $(DOWNLOAD_DIR)/$(PACKAGES_BUSYBOX_FILE) -C $(TARGET_INITRAMFS_BUILD_DIR)
else ifeq ($(suffix $(PACKAGES_BUSYBOX_FILE)), .gz)
	$(TAR) -xzf $(DOWNLOAD_DIR)/$(PACKAGES_BUSYBOX_FILE) -C $(TARGET_INITRAMFS_BUILD_DIR)
else
	$(error Unknown archive format in: $(PACKAGES_BUSYBOX_FILE))
endif

TARGET_INITRAMFS_BUSYBOX_BUILD := $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR)/busybox 
$(TARGET_INITRAMFS_BUSYBOX_BUILD): $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR)/Makefile $(TARGET_INITRAMFS_BUSYBOX_CONFIG)
	$(CP) -a $(TARGET_INITRAMFS_BUSYBOX_CONFIG) $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR)/.config
	$(PACKAGES_ENV) $(MAKE) -C $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR) oldconfig CONFIG_STATIC=y
	$(PACKAGES_ENV) $(MAKE) -C $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_STATIC=y all

TARGET_INITRAMFS_BUSYBOX_INSTALL := $(TARGET_INITRAMFS_DIR)/bin/busybox 
$(TARGET_INITRAMFS_BUSYBOX_INSTALL): $(TARGET_INITRAMFS_BUSYBOX_BUILD)
	$(PACKAGES_ENV) $(MAKE) -C $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_STATIC=y CONFIG_PREFIX=$(TARGET_INITRAMFS_DIR) install


ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

TARGET_INITRAMFS_CREATE = $(TARGET_ROOTFS_DIR)/boot/$(TARGET_INITRAMFS_FILENAME) 	
$(TARGET_INITRAMFS_CREATE): $(ROOT)/target/initramfs.mk $(TARGET_INITRAMFS_DIRS) $(TARGET_INITRAMFS_INIT) $(TARGET_INITRAMFS_BUSYBOX_BUILD) $(TARGET_INITRAMFS_BUSYBOX_INSTALL)
	cp -a /dev/{null,console,tty} $(TARGET_INITRAMFS_DIR)/dev/
	(cd $(TARGET_INITRAMFS_DIR); \
		find . -print | cpio -o -H newc | gzip -9 > $(TARGET_INITRAMFS_CREATE); \
	);

.PHONY: target-initramfs-distclean
target-initramfs-distclean:
ifeq ($(UID), 0)
	-$(RM) -Rf $(TARGET_INITRAMFS_DIR) $(TARGET_INITRAMFS_BUILD_DIR)
else
	$(error you need to be root)
endif

TARGET_DISTCLEAN_TARGETS += target-initramfs-distclean

.NOTPARALLEL: