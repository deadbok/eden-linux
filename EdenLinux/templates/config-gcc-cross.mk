$target: $dependencies $toolchain_build_dir/gcc-${version}/configure 
	(cd $current_package_dir; \
		LDFLAGS=$(LDFLAGS) $root/$toolchain_build_dir/gcc-${version}/configure $config_opts \
	);
	$touch $target