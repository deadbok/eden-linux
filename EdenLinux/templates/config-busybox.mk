$target: $dependencies
	$cp $root/$package_file_dir/config $root/$current_package_dir/.config
	$env_packages $make -C $current_package_dir oldconfig
