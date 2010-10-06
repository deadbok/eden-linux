$target: $dependencies
	if test -f $current_package_dir/.patches; \
	then echo Package allready patched; \
	else $patchall $root/$package_file_dir $root/$current_package_dir; \
	fi
	$touch $target