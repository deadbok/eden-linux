#########################
.conf configuration files
#########################
The configuration files are for adding variables, and packages to the build system.

=========
Sections:
=========
A section is a namespace, that can access all global variables, but export the local
variables to globals, postfixed by the section name. A .conf file, with no section definition,
is added to the global namespace.

A section is defined like this::

	section_name:
	
It is good practise to indent the contents of a section, to make the file easier to read.
The section definition is ended like this::

	:section_name

Sections work by postfixing the variables in the section, with the section name. A section definition
like this::

	cc = i686-pc-linux-uclibc
	package:
		name = gcc
		version = 4.4.1
		dependencies = $toolchain
	:package
	
will generate the following code::

	CC = i686-pc-linux-uclibc
	NAME_PACKAGE = gcc
	VERSION_PACKAGE = 4.4.1
	DEPENDENCIES_PACKAGE = $(TOOLCHAIN)

=========
Variables
=========
Variables are handled much like in Makefiles. A variable is defined like this::

	variable_name = value

.. attention
Since the comma, ",", character is used in function definitions, to split function
parameters, the substitution in a variable value is "\,"

Variable scope
==============

Global variables
----------------
When a variable is defined outside a section, it is global. To reference a global
variable add a dollar sign ($) in front of the name like this::

	spam = 1
	eggs = $spam
	
In the example eggs is set to equal the value of spam, which is 1.

Local variables
---------------
Variables defined inside a section, is local to that section the are referenced 
by inclosing them in {} characters like this::

	package:
		version = 1.0
		filename = package-${version}
	:package

===========
build tasks
===========
A build task translates to a target in the final makefile. The syntax, is mostly like a C
function.

unpack($current_package_dir/configure)
config(config-gmp.mk, config_opts = --prefix=$root/$toolchain_root_dir --enable-shared --with-gmp=$root/$toolchain_root_dir, $current_package_dir/Makefile)
build($current_package_dir/libmpfr.la)
install($toolchain_root_dir/lib/libmpfr.a)

