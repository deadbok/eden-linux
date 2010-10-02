$target: $dependencies
	[ ! -s $root/$(strip $target) ] || $patchall $root/$package_file_dir $root/$current_package_dir
	$touch $target