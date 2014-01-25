#mtl
${local_namespace("packages.kbd")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --host=$(ARCH_TARGET) 
#Override some autoconf variables to force certain checks regarding malloc to pass
${local()}CONFIG_ENV = $(PACKAGES_ENV) ac_cv_func_setpgrp_void=yes ac_cv_func_malloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${AutoconfPackage('$(PACKAGES_BUILD_DIR)/kbd-$(PACKAGES_KBD_VERSION)', '', '1.15', "http://www.kbd-project.org/download/kbd-$(PACKAGES_KBD_VERSION).tar.bz2", "$(ROOTFS_DIR)/usr/bin/mke2fs")}
	
#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_KBD_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_KBD_INSTALL)
PACKAGES_NAME_TARGETS += e2fsprogs
.NOTPARALLEL: