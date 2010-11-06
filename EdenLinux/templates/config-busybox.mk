${target}: ${dependencies}
	$cp $busybox_config_target ${current_package_dir}/.config
	$env_packages $make -C ${current_package_dir} oldconfig
