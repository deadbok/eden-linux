$target: $toolchain_build_dir/gcc-$(version)/configure $toolchain_build_dir/$(dir)
	(cd $current_package_dir; \
		LDFLAGS=$(LDFLAGS) AR=ar $root/$toolchain_build_dir/gcc-$(version)/configure $config_opts \
	);