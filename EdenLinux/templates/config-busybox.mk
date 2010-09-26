$target: $dependencies
	$cp $package_file_dir/config $current_package_dir/.config
	$toolchain_env $make -C $current_package_dir oldconfig
