$target: $dependencies $current_copy_target
	PATH=$(PATH_TOOLCHAIN) $make -C $current_package_dir oldconfig
	PATH=$(PATH_TOOLCHAIN) $make -C $current_package_dir CROSS=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc" KERNEL_HEADERS=$(ROOT)/$(ROOTFS_DIR)/usr/include RUNTIME_PREFIX="$(ROOT)/$(ROOTFS_DIR)/"
	$touch $current_package_dir/.patched

	