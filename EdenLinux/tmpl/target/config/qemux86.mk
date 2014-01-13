#mtl
${local_namespace("target")}

${local()}PROCESSOR = i686
${local()}FILE_SYSTEM = iso
${local()}UCLIBC_CONFIG = $(ROOT)/target/config/qemux86/config/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/config/qemux86/config/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/config/qemux86/config/busybox_config
${local()}INITRAMFS_BUSYBOX_CONFIG = $(ROOT)/target/qemux86/config/initramfs_busybox_config
.NOTPARALLEL: