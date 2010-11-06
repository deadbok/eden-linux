${target}: $download_dir/${packed_filename} ${dependencies}
	$unpack $download_dir/${packed_filename} ${unpack_dir}
	$mkdir ${current_package_dir}
	$rm ${current_package_dir}/.patched
	$touch ${target}
