${target}: ${dependencies} ${current_package_dir}/vmlinux
	$cp ${current_package_dir}/System.map $rootfs_dir/boot/System.map-${version}
	$cp ${current_package_dir}/arch/$distbuild_target/boot/bzImage $rootfs_dir/boot/kernel-${version}
	$cp ${current_package_dir}/.config $rootfs_dir/boot/config-${version}
	$env_packages $make -C ${current_package_dir} ARCH=$kernel_arch CROSS_COMPILE=$(ARCH_TARGET)- modules_install INSTALL_MOD_PATH=$root/$rootfs_dir
	$root/$rootfs_dir/sbin/depmod.pl -F $root/$rootfs_dir/boot/System.map-${version} -b $root/$rootfs_dir/lib/modules/$(version)