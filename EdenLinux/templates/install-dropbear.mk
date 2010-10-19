${target}: ${dependencies}
	$env_packages $make -C ${current_package_dir} install ${make_opts}
	ln -svf ../../usr/bin/dropbearmulti $rootfs_dir/usr/sbin/dropbear
	ln -svf ../../usr/bin/dropbearmulti $rootfs_dir/usr/bin/dbclient
	ln -svf ../../usr/bin/dropbearmulti $rootfs_dir/usr/bin/dropbearkey
	ln -svf ../../usr/bin/dropbearmulti $rootfs_dir/usr/bin/dropbearconvert
	ln -svf ../../usr/bin/dropbearmulti $rootfs_dir/usr/bin/scp
	$touch ${target}