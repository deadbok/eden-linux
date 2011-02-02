${target}: $download_dir/${packed_filename} ${dependencies}
	$unpack $(VERBOSE_FLAG) $download_dir/${packed_filename} ${unpack_dir}
	$mkdir ${current_package_dir}
	$rm ${current_package_dir}/.patched
	$touch ${target}
