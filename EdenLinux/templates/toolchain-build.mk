$target: $dependencies $current_config_target
	$make -C $current_package_dir
	$touch $target