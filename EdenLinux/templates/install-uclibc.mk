${target}: ${dependencies}
	PATH=$(PATH_TOOLCHAIN) $make -C ${current_package_dir} PREFIX=$root/$rootfs_dir install
	$touch ${target}
