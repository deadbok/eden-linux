#mtl
${local_namespace("target")}

${local()}PROCESSOR = i686
${local()}FILE_SYSTEM = iso
${local()}UCLIBC_CONFIG = $(ROOT)/target/x86/uclibc_config
${local()}KERNEL_CONFIG = $(ROOT)/target/x86/kernel_config
${local()}BUSYBOX_CONFIG = $(ROOT)/target/x86/busybox_config

#target:
#	processor = i686
#	image_type = vmware
#	file_system = iso
#	uclibc_config = ${root}/conf/target/x86/uclibc_config
#	kernel_config = ${root}/conf/target/x86/kernel_config
#	busybox_config = ${root}/conf/target/x86/busybox_config
#	
#	install = ${build.iso.target}
#:target

.NOTPARALLEL: