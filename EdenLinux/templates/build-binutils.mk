$target: $current_config_target
	$make -C $current_package_dir configure-host
	$make -C $current_package_dir