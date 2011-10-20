#mtl
${local_namespace("packages.kernel")}

#${package("$(PACKAGES_BUILD_DIR)/linux-$(PACKAGES_KERNEL_VERSION)", "", "2.6.39", "linux-$(PACKAGES_KERNEL_VERSION).tar.bz2", "http://linux-kernel.uio.no/pub/linux/kernel/v2.6/$(PACKAGES_KERNEL_FILE)")}
${Package("$(PACKAGES_BUILD_DIR)/linux-$(PACKAGES_KERNEL_VERSION)", "", "2.6.39", "http://linux-kernel.uio.no/pub/linux/kernel/v2.6/linux-$(PACKAGES_KERNEL_VERSION).tar.bz2", "$(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)")}
#Special rule, while kernel.org is down
#${download}
#$(DOWNLOAD_DIR)/v2.6.30:
#	$(WGET) $(PACKAGES_KERNEL_URL) -P $(DOWNLOAD_DIR)
#
#$(DOWNLOAD_DIR)/$(PACKAGES_KERNEL_FILE): $(DOWNLOAD_DIR)/v2.6.30
#	$(CP) $(DOWNLOAD_DIR)/v2.6.30 $(DOWNLOAD_DIR)/$(${local}FILE)

#${unpack("$(PACKAGES_BUILD_DIR)", "$(PACKAGES_KERNEL_SRC_DIR)/Makefile")}
${UnpackRule("$(DOWNLOAD_DIR)/$(PACKAGES_KERNEL_FILE)", "$(PACKAGES_BUILD_DIR)", "$(PACKAGES_KERNEL_SRC_DIR)/Makefile")}

$(PACKAGES_KERNEL_SRC_DIR)/.config: $(TARGET_KERNEL_CONFIG)
	$(CP) -a $(TARGET_KERNEL_CONFIG) $(PACKAGES_KERNEL_SRC_DIR)/.config

PACKAGES_KERNEL_BUILD = $(PACKAGES_KERNEL_BUILD_DIR)/vmlinux
$(PACKAGES_KERNEL_BUILD): $(PACKAGES_KERNEL_UNPACK) $(PACKAGES_KERNEL_SRC_DIR)/.config
	$(PACKAGES_ENV) $(MAKE) CONFIG_ISO9660_FS=y -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- oldconfig
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)-

include packages/busybox.mk
	
PACKAGES_KERNEL_INSTALL = $(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)
$(PACKAGES_KERNEL_INSTALL): $(PACKAGES_KERNEL_BUILD) $(ROOTFS_DIR)/sbin/depmod.pl
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/System.map $(ROOTFS_DIR)/boot/System.map-$(PACKAGES_KERNEL_VERSION)
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/arch/$(TARGET)/boot/bzImage $(ROOTFS_DIR)/boot/kernel-$(PACKAGES_KERNEL_VERSION)
	$(CP) $(PACKAGES_KERNEL_BUILD_DIR)/.config $(ROOTFS_DIR)/boot/config-$(PACKAGES_KERNEL_VERSION)
	$(TOOLCHAIN_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- modules_install INSTALL_MOD_PATH=$(ROOTFS_DIR)
	$(ROOTFS_DIR)/sbin/depmod.pl -F $(ROOTFS_DIR)/boot/System.map-$(PACKAGES_KERNEL_VERSION) -b $(ROOTFS_DIR)/lib/modules/$(PACKAGES_KERNEL_VERSION)

kernel-menuconfig:
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_KERNEL_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- menuconfig

#packages:
#	linux-kernel:
#		version = 2.6.30
#		dir = linux-${version}
#		group = basesystem
#		url = ftp://ftp.dk.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
#
#		#Already in linux-kernel-headers, in toolchain	
#		#download()
#		unpack(${root}/${build_dir.packages}/${dir}/Makefile)
#		copy(${root}/${build_dir.packages}/${dir}/.config, source="${kernel_config.target}", ${kernel_config.target})
#		build(build-linux-kernel.mk, ${build_dir.packages}/${dir}/vmlinux, ${unpack} ${copy})
#		install(install-linux-kernel.mk, $rootfs_dir/boot/kernel-${version}, ${rootfs_dir}/lib/modules/${version}/modules.dep, ${rootfs_dir}/boot/.dir ${root}/${rootfs_dir}/sbin/.dir ${root}/${rootfs_dir}/sbin/depmod.pl)
#		clean()
#		distclean()
#	:linux-kernel  
#:packages

.NOTPARALLEL: