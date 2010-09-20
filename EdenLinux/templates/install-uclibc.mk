$target: $current_build_target
	PATH=$(TOOLCHAIN_PATH) $make -C $current_package_dir PREFIX=$root/$rootfs_dir/ install
	$touch $target
