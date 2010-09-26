$target: $download_dir/$packed_filename $unpack_dir $dependencies
	$unpack $download_dir/$packed_filename $unpack_dir
	$touch $target