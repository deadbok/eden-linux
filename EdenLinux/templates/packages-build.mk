${target}: ${dependencies} ${current_package_dir}/Makefile
	$env_packages $make -C ${current_package_dir} ${make_opts}
