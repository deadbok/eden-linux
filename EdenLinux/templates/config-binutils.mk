${target}: ${dependencies} 
	(cd ${current_package_dir}; \
		LDFLAGS=$(LDFLAGS) $root/$build_dir_toolchain/binutils-${version}/configure ${config_opts} \
	);
	$touch ${target}