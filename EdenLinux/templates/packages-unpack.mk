$target: $download_dir/$packed_filename $unpack_dir $dependencies
	$unpack $download_dir/$packed_filename $unpack_dir
	$rm $current_package_dir/.patched
	$touch $target