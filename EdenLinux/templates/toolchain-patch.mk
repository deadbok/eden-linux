${target}: ${dependencies}
	if test -f $root/${current_package_dir}/.patched; \
	then echo Package allready patched; \
	else $patchall $root/${package_file_dir} $root/${current_package_dir}; \
	fi
	$touch ${target}