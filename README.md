Introduction
============

The overall goal for this project is to build a system that builds tailor-made 
Linux distributions. There are a whole range of these tools available on the net
but when I began trying to add more software, found it awkward and tiresome, 
this was at least 3 years ago and things may have gotten better.

As it stands now, this is not easier to use, but I know the ins and outs of
my own build system better.

I started using make to create a set of makefiles to build the distribution, 
like Buildroot. I quickly got to the point where I was writing the same code for
different packages that I wanted in the system. A lot of packages for example 
uses the GNU build system, and requires almost the same commands to build them.
This was tiresome as well, so I began creating a template system for makefiles.
The idea is that when you have a basic Autoconf package, you can write one
simple line of code, and the template engine generates the actual makefile,
with all the rules needed to build and install the software on the target.

As it stands, this is working. The thing is done in Python, and uses Python for
the template language as well. I am a bit disappointed with the complexity of what
I've come up with this far, it really isn't cleaner or simpler than Buildroot.

The main problem is the complexity of tweaking and building a Linux distribution
cross-compiled. There are all sorts of bad behavior and corner cases, for a lot
of packages. This means that the makefiles needed to build a distribution are a
pretty complex matter in itself. The template engine does succeed in simplifying
the makefiles, but it also ads more complexity on top of the use of makefiles.
To use the template engine you need to have a good knowledge og how Make works.
All in all you end up needing to know a lot about Make, and how the template
engine works, instead of just knowing how make works.

Breaking it down:
=================
EdenLinux consists of three sub projects:
 * The Make file TempLate system (mtl)
 * The make file templates
 * The final make file build system

Directories
===========
 *                          - build Where the makefiles are created and everything is build
 	* dl                      - All downloaded sources
 	* host_$(HOST)            - Compiled tools that run on the host
 	* host_$(HOST)_build      - Where host tools are compiled
 	* images                  - The final disk images
 	* image_rootfs_$(TARGET)  - The final root file system for the target
 	* packages_$(ARCH)_build  - Where all target packages are build
 	* rootfs_$(ARCH)          - The raw root file system for the target arch
 	* tmp                     - Housekeeping files mostly
 	* toolchain_$(ARCH)       - Compiled toolchain for target arch
 	* toolchain_$(ARCH)_build - Where the toolchain for the target arch is build
 * docs	                    - Misc docs from the net I have found useful
 * mtl                      - The Make TempLate engine converts the templates 
                              to real makefiles 
 * plugins	                - Plugin for various makefile constructs
 * tmpl	                    - Makefile templates read by mtl
 * tools	                - Various tools to make life easier when using the
                              build system
Credits
=======
All who care to post questions and solutions on the net, and all the developers
behind all the software that I use in this project.
 
 * Buildroot
 * Gentoo
 * (Cross compiled) Linux From Scratch
 
OpenRC and most of the init files are taken from Gentoo.

Best of luck.
*Martin Grønholdt*
