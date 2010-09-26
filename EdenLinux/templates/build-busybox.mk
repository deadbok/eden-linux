$target: $dependencies
	$toolchain_env $make -C $current_package_dir ARCH=$kernel_arch CROSS_COMPILE=$(ARCH_TARGET)- CC="$(ARCH_TARGET)-gcc"
	$touch $target
