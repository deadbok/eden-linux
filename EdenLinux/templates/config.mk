$target: $dependencies $current_package_dir/configure
	(cd $current_package_dir; \
		./configure $param \
	);

