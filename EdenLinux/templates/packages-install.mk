${target}: ${dependencies} ${current_build_target}
	$env_packages $make -C ${current_package_dir} install ${make_opts}
	$touch ${target}
