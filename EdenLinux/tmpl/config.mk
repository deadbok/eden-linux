#mtl
${configfile()}

${ConfigVarItem('compress_man_pages', True, "Compress MAN pages", "Compresses the manpages with bzip2 to save space")}

${ConfigVarItem('verbose', False, "Verbose messages", "Print much more information while building")}

STRIP_TARGET = 1
MAKE_PROCESSES=2
REMOVE_HEADERS = 1
TARGET := x86

#${ConfigVarChoice('arch', 'i686', 'Target processor architecture', 'Select the architecture to optimize code for.', ['i486', 'i686'])}
KERNEL_ARCH := i386
ARCH_TARGET := $(ARCH)-pc-linux-uclibc
#Host type definition
HOST_ARCH := i686
HOST := $(HOST_ARCH)-pc-linux-gnu

ROOT_DEVICE := /dev/sda1
SWAP_DEVICE := /dev/sda2