.conf configuration files
=========================
The configuration files are for adding variables, and packages to the build system.

Variables
=========
Variables are handled much like in Makefiles. A variable is defined like this::

	variable_name = value
	
To reference a variable add a dollar sign ($) in front of the name like this::

	spam = 1
	eggs = $spam
	
In the example eggs is set to equal the value of spam, which is 1.

\, = ,

Sections:
=========
A section is a namespace, that can access all global variables, but export the local
variables, prefixed by the section name.

A section is defined like this::

	section_name:
	
It is good practise to indent the contents of a section, to make the file easier to read.
The section definition is ended like this::

	:section_name

Sections work by prefixing the variables in the section, with the section name. A section definition
like this::

	package:
		name = gcc
		version = 4.4.1
		dependencies = $toolchain
	:package
	

Local variables
===============
$(variable_name) the scope of a local variable is within the file in which it is defined 

build tasks
===========

unpack($current_package_dir/configure)
config(config-gmp.mk, config_opts = --prefix=$root/$toolchain_root_dir --enable-shared --with-gmp=$root/$toolchain_root_dir, $current_package_dir/Makefile)
build($current_package_dir/libmpfr.la)
install($toolchain_root_dir/lib/libmpfr.a)

