$target: $current_package_dir/Makefile $current_package_dir/.config
	$toolchain_env $make -C $current_package_dir ARCH=$kernel_arch CROSS_COMPILE=$(ARCH_TARGET)- oldconfig
	$toolchain_env $make -C $current_package_dir ARCH=$kernel_arch CROSS_COMPILE=$(ARCH_TARGET)-
	$touch $current_package_dir/.build
