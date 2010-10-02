$target: $dependencies $current_build_target
	$env_packages $make -C $current_package_dir install $make_opts
	$cp $root/$package_file_dir/80-drivers.rules $root/$rootfs_dir/etc/udev/rules.d/80-drivers.rules