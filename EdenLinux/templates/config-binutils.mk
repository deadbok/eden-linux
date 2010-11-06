${target}: ${dependencies} $build_dir_toolchain/${dir}
	(cd ${current_package_dir}; \
		LDFLAGS=$(LDFLAGS) $root/$build_dir_toolchain/binutils-${version}/configure ${config_opts} \
	);
	$touch ${target}