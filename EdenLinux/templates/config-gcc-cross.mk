${target}: ${dependencies}
	(cd ${current_package_dir}; \
		LDFLAGS=$(LDFLAGS) $root/$build_dir_toolchain/gcc-${version}/configure ${config_opts} \
	);
	$touch ${target}