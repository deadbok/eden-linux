$target: $current_build_target
	$make -C $current_package_dir install $make_opts
	$make -C $current_package_dir install-libs $make_opts