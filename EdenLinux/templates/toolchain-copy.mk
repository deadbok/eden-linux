$target: $dependencies
	$mkdir $(dir $rootfs_dir/$target)
	$cp $dependencies $target