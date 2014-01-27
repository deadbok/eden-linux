#mtl
${local_namespace("packages.base")}

#Tell where we are at
${local()}FILE_DIR = $(ROOT)/packages/base

#WARNING: These are ordered according to dependencies
include packages/base/openrc.mk

include packages/base/busybox.mk

include packages/base/bootdevs.mk

include packages/base/baseconf.mk

include packages/base/iana-etc.mk

include packages/base/ncurses.mk
include packages/base/nano.mk

include packages/base/udev.mk

include packages/base/e2fsprogs.mk

include packages/base/kbd.mk

include packages/base/zlib.mk
include packages/base/dropbear.mk

include packages/base/util-linux.mk

include packages/base/netifrc.mk

.NOTPARALLEL: