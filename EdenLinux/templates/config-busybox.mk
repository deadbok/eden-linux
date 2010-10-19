${target}: ${dependencies}
	$cp $busybox_config_target $root/${current_package_dir}/.config
	$env_packages $make -C ${current_package_dir} oldconfig
