$target: $dependencies $current_package_dir/Makefile
	$make -C $current_package_dir mrproper
	$make -C $current_package_dir ARCH=$kernel_arch headers_check
	$touch $current_package_dir/.build