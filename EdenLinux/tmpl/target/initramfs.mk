#mtl
${local_namespace("target.initramfs")}

${local()}DIR := $(BUILD_DIR)/initramfs
${local()}FILENAME := initrd.gz
${local()}BUILD_DIR := $(TARGET_INITRAMFS_DIR)_$(ARCH)_build

TARGET_INITRAMFS_DIRS := $(addprefix $(TARGET_INITRAMFS_DIR)/,bin lib dev etc mnt/root proc sbin sys)
$(TARGET_INITRAMFS_DIRS):
	$(MKDIR) $(TARGET_INITRAMFS_DIR)/{bin,lib,dev,etc,mnt/root,proc,sbin,sys}

TARGET_INITRAMFS_INIT := $(TARGET_INITRAMFS_DIR)/init
$(TARGET_INITRAMFS_INIT): $(ROOT)/target/initramfs/init
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
$(TARGET_INITRAMFS_BUSYBOX_BUILD): $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR)/Makefile
	$(TOOLCHAIN_ENV) $(MAKE) -C $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR) defconfig
	$(TOOLCHAIN_ENV) $(MAKE) -C $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_STATIC=y

TARGET_INITRAMFS_BUSYBOX_INSTALL := $(TARGET_INITRAMFS_DIR)/bin/busybox 
$(TARGET_INITRAMFS_BUSYBOX_INSTALL): $(TARGET_INITRAMFS_BUSYBOX_BUILD)
	$(TOOLCHAIN_ENV) $(MAKE) -C $(TARGET_INITRAMFS_BUSYBOX_SRC_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_STATIC=y CONFIG_PREFIX=$(TARGET_INITRAMFS_DIR) install


ifeq ($(UID), 0)
LOOP_DEVICE = $(shell losetup -f)
endif

TARGET_INITRAMFS_CREATE = $(ROOTFS_DIR)/boot/$(TARGET_INITRAMFS_FILENAME) 	
$(TARGET_INITRAMFS_CREATE): $(TARGET_INITRAMFS_DIRS) $(TARGET_INITRAMFS_INIT) $(TARGET_INITRAMFS_BUSYBOX_BUILD) $(TARGET_INITRAMFS_BUSYBOX_INSTALL)
	cp -a /dev/{null,console,tty} $(TARGET_INITRAMFS_DIR)/dev/
	(cd $(TARGET_INITRAMFS_DIR); \
		find . -print | cpio -o -H newc | gzip -9 > $(TARGET_INITRAMFS_CREATE); \
	);			


#target:
#	initramfs:
#		dir = initramfs
#		filename = initrd.gz
#		
#		mkdirs(${root}/${distbuild_dir}/${dir}/.dirs)
#		{
#			${target}: ${dependencies}
#				mkdir -p ${root}/${distbuild_dir}/${dir}/{bin,lib,dev,etc,mnt/root,proc,sbin,sys}
#				touch ${root}/${distbuild_dir}/${dir}/.dirs
#		}
#		
#		init(${root}/${distbuild_dir}/${dir}/init, ${root}/conf/target/initramfs/init)
#		{
#			${target}: ${dependencies}
#				cp ${root}/conf/target/initramfs/init ${target}
#				chmod +x ${target}
#		}
#		
#		busybox-build(${root}/${distbuild_dir}/${dir}_$(ARCH)_build/busybox/busybox)
#		{
#			${target}: ${dependencies}
#				mkdir -p ${root}/${distbuild_dir}/${dir}_$(ARCH)_build/busybox
#				${env.toolchain} make -C ${root}/${distbuild_dir}/${dir}_$(ARCH)_build/busybox KBUILD_SRC=${root}/${build_dir.packages}/${src_dir.busybox.packages} -f ${root}/${build_dir.packages}/${src_dir.busybox.packages}/Makefile defconfig
#				${env.toolchain} $make -C ${root}/${distbuild_dir}/${dir}_$(ARCH)_build/busybox ARCH=$kernel_arch CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_STATIC=y
#		}
#		
#		busybox-install(${root}/${distbuild_dir}/${dir}/bin/busybox, ${busybox-build})
#		{
#			${target}: ${dependencies}
#				${env.toolchain} $make -C ${root}/${distbuild_dir}/${dir}_$(ARCH)_build/busybox ARCH=$kernel_arch CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" CONFIG_STATIC=y CONFIG_PREFIX=${root}/${distbuild_dir}/${dir} install
#		}
#
#		create(${root}/${rootfs_dir}/boot/${filename}, ${root}/${distbuild_dir}/${dir}/.dirs ${root}/${distbuild_dir}/${dir}/init ${busybox-install} )
#		{
#			ifeq (${uid}, 0)
#			LOOP_DEVICE = $(shell losetup -f)
#			endif
#			
#			${target}: ${dependencies}
#				cp -a /dev/{null,console,tty} ${root}/${distbuild_dir}/${dir}/dev/
#
#				(cd ${root}/${distbuild_dir}/${dir}; \
#					find . -print | cpio -o -H newc | gzip -9 > ${target}; \
#					cd ${root}; \
#				);			
#		}
#	:initramfs
#:target

.NOTPARALLEL: