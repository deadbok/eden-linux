$target: $dependencies $current_build_target
	$make -C $current_package_dir install-gcc install-target-libgcc
	$touch $target