${target}: ${dependencies}
	(cd ${current_package_dir}; \
		$env_packages LDFLAGS=$(LDFLAGS) ./configure ${config_opts} \
	);