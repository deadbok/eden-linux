$target: $dependencies $current_package_dir/vmlinux
	$cp $current_package_dir/System.map $rootfs_dir/boot/System.map-$(version)
	$cp $current_package_dir/arch/$build_target/boot/bzImage $rootfs_dir/boot/kernel-$(version)
	$cp $current_package_dir/.config $rootfs_dir/boot/config-$(version)
	$rootfs/sbin/depmod.pl -F $rootfs_dir/boot/System.map-$(version) -b $rootfs_dir/lib/modules/$(version)