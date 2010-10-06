$target: $download_dir/$packed_filename $unpack_dir
	$unpack $download_dir/$packed_filename $unpack_dir
	$rm $current_package_dir/.patched
	$touch $target