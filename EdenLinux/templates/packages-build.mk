${target}: ${dependencies}
	$env_packages $make -C ${current_package_dir} ${make_opts}
