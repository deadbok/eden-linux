$target: $dependencies $current_build_target
	$env_packages $make -C $current_package_dir install $make_opts
	$env_packages $make -C $current_package_dir install-libs $make_opts
	$touch $packages_build_dir/e2fsprogs-${version}/configure
	$touch $current_package_dir/Makefile
	$touch $current_package_dir/misc/mke2fs
	$touch $rootfs_dir/sbin/mke2fs