$target: $toolchain_build_dir/binutils-$(version)/configure $toolchain_build_dir/$(dir)
	(cd $current_package_dir; \
		LDFLAGS=$(LDFLAGS) $root/$toolchain_build_dir/binutils-$(version)/configure $config_opts \
	);