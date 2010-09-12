$target: $toolchain_build_dir/gcc-$(version)/configure $toolchain_build_dir/$(dir)
	(cd $current_package_dir; \
		AR=ar LDFLAGS=$(LDFLAGS) $root/$toolchain_build_dir/gcc-$(version)/configure $config_opts \
	);
	touch $target