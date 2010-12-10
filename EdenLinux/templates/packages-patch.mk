${target}: ${dependencies}
	$patchall $root/${package_file_dir} $root/$(dir ${target})
	$touch ${target}