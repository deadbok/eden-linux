$target: $dependencies
	(cd $current_package_dir; \
		LDFLAGS=$(LDFLAGS) ../configure $config_opts \
	);