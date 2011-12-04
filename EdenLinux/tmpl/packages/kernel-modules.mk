#mtl
${local_namespace("packages.kernel-modules")}

include packages/aufs.mk

PACKAGES_KERNEL_MODULES += $(PACKAGES_AUFS_PATCH)

.NOTPARALLEL: