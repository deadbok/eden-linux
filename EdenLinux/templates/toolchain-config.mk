${target}: ${current_package_dir}/configure ${dependencies}
	(cd ${current_package_dir}; \
		LDFLAGS=$(LDFLAGS) ./configure ${config_opts} \
	);
	$touch ${target}