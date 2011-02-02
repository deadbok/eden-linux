${target}: ${dependencies}
	$make -C ${current_package_dir} ARCH=$kernel_arch INSTALL_HDR_PATH=$root/$rootfs_dir/usr headers_install