#mtl
${local_namespace("packages.tools.lcdproc")}

${local()}INSTALL_PARAM = DESTDIR=$(ROOTFS_DIR)
${local()}INSTALL_ENV = $(PACKAGES_ENV)

${local()}CONFIG_PARAM = --prefix=/usr --target=$(ARCH_TARGET) \
						 --host=$(ARCH_TARGET) --build=$(HOST)

${local()}CONFIG_ENV = $(PACKAGES_ENV)

${local()}BUILD_PARAM = 
${local()}BUILD_ENV = $(PACKAGES_ENV) 

${local()}DEPENDENCIES =

SERVICES += LCDd lcdproc

${py lcdproc = AutoconfPackage('$(PACKAGES_BUILD_DIR)/lcdproc-$(PACKAGES_TOOLS_LCDPROC_VERSION)', '', '0.5.6', "http://downloads.sourceforge.net/project/lcdproc/lcdproc/0.5.6/lcdproc-$(PACKAGES_TOOLS_LCDPROC_VERSION).tar.gz", "$(ROOTFS_DIR)/usr/bin/lcdproc")}

${lcdproc.vars()}

${lcdproc.rules['download']}

${lcdproc.rules['unpack']}
	($(CD) $(PACKAGES_TOOLS_LCDPROC_BUILD_DIR); $(AUTORECONF));

${lcdproc.rules['patchall']}

${lcdproc.rules['config']}

${lcdproc.rules['build']}

${lcdproc.rules['install']}
	$(CP) -R $(ROOT)/${namespace.current.replace(".", "/")}/etc $(ROOTFS_DIR)/

#Add to targets
PACKAGES_INSTALL_TARGETS += $(PACKAGES_TOOLS_LCDPROC_INSTALL)
PACKAGES_NAME_TARGETS += ${namespace.current}

.NOTPARALLEL: