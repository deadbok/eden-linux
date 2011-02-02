${target}: ${dependencies}
	$make -C ${current_package_dir} configure-host
	$make -C ${current_package_dir}
