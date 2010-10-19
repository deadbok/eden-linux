${target}: ${dependencies} $build_dir_toolchain/gcc-${version}/configure $build_dir_toolchain/${dir}
	(cd ${current_package_dir}; \
		AR=ar LDFLAGS=$(LDFLAGS) $root/$build_dir_toolchain/gcc-${version}/configure ${config_opts} \
	);
	$touch ${target}