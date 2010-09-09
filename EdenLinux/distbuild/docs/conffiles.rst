.conf configuration files
=========================
The configuration files are for adding variables, and packages to the build system.

build tasks
===========

unpack($current_package_dir/configure)
config(config-gmp.mk, config_opts = --prefix=$root/$toolchain_root_dir --enable-shared --with-gmp=$root/$toolchain_root_dir, $current_package_dir/Makefile)
build($current_package_dir/libmpfr.la)
install($toolchain_root_dir/lib/libmpfr.a)