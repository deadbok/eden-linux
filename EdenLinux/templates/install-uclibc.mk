$target: $current_build_target
	PATH=$(TOOLCHAIN_PATH) $make -C $current_package_dir install PREFIX=$root/$rootfs_dir
	$touch $target
