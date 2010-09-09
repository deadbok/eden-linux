Introduction
============

Distbuild is a tool to generate Makefiles for building custom linux distributions.
Distbuild was written to simplify the task of adding custom software, to the Makefile driven
build system I had developed for EdenLinux, a distribution I was building for a VIA Eden based
SBC. Distbuild parses a tree of config files, and Makefile templates, and spits out a Makefile based
build system.