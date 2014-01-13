#mtl
${local_namespace("target")}

${local()}PROCESSOR = i686
${local()}FILE_SYSTEM = iso
${local()}UCLIBC_CONFIG = $(ROOT)/target/x86/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/x86/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/x86/busybox_config
${local()}INITRAMFS_BUSYBOX_CONFIG = $(ROOT)/target/x86/initramfs_busybox_config
.NOTPARALLEL: