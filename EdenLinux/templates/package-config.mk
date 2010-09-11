$target: $current_package_dir/configure
	(cd $current_package_dir; \
		LDFLAGS=$(LDFLAGS) ./configure $config_opts \
	);