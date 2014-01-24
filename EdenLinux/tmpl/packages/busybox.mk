#mtl
#Set namespace (All generated variables will be prefixed with PACKAGES_BUSYBOX)
${local_namespace("packages.busybox")}

#Define a busybox package
${py busybox = Package("$(PACKAGES_BUILD_DIR)/busybox-$(PACKAGES_BUSYBOX_VERSION)", "", "1.21.1", "http://busybox.net/downloads/busybox-$(PACKAGES_BUSYBOX_VERSION).tar.bz2", "$(ROOTFS_DIR)/bin/busybox")}

#Add download rule
${py busybox.rules['download'] = DownloadRule("$(PACKAGES_BUSYBOX_URL)")}

#Add unpack rule
${py busybox.rules['unpack'] = UnpackRule("$(DOWNLOAD_DIR)/$(PACKAGES_BUSYBOX_FILE)", "$(PACKAGES_BUILD_DIR)", "$(PACKAGES_BUSYBOX_SRC_DIR)/Makefile")}

#Add config rule
${py busybox.rules['config'] = Rule("$(PACKAGES_BUSYBOX_BUILD_DIR)/.config", "$(PACKAGES_BUSYBOX_SRC_DIR)/Makefile $(TARGET_BUSYBOX_CONFIG)", rule_var_name = var_name("config"))}

#Add depmod rule (The depmod util is needed for the kernel install)
${py busybox.rules['depmod'] = Rule("$(ROOTFS_DIR)/sbin/depmod.pl", "$(PACKAGES_BUSYBOX_SRC_DIR)/Makefile", rule_var_name = var_name("depmod"))}

#Add build rule
${py busybox.rules['build'] = MakeRule("$(PACKAGES_ENV)", 'ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)-', "$(PACKAGES_BUSYBOX_BUILD_DIR)", "all", "$(PACKAGES_BUSYBOX_BUILD_DIR)/busybox", "$(PACKAGES_BUSYBOX_CONFIG)", var_name("build"))}	

#Add rule for the udhcpc script (Needed at boot for network dhcp)
${py busybox.rules['udhcpc-script'] = Rule('$(ROOTFS_DIR)/etc/network/udhcpc.script', rule_var_name=var_name("udhcpc-script"))}

#Add install rule
${py busybox.rules['install'] = MakeRule("$(PACKAGES_ENV)", 'ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- CONFIG_PREFIX=$(ROOTFS_DIR)', "$(PACKAGES_BUSYBOX_BUILD_DIR)", "install", "$(ROOTFS_DIR)/bin/busybox", "$(PACKAGES_BUSYBOX_BUILD) $(PACKAGES_BUSYBOX_UDHCPC-SCRIPT)", var_name("install"))}

#Output package variables
${busybox.vars()}

#Output download rule
${busybox.rules['download']}

#Output unpack rule
${busybox.rules['unpack']}

#Output config rule
${busybox.rules['config']}
	$(CP) -a $(TARGET_BUSYBOX_CONFIG) $(PACKAGES_BUSYBOX_BUILD_DIR)/.config
	$(PACKAGES_ENV) $(MAKE) ARCH=$(KERNEL_ARCH) CROSS_COMPILE="$(ARCH_TARGET)-" -C $(PACKAGES_BUSYBOX_BUILD_DIR) oldconfig

#Output config depmod
${busybox.rules['depmod']}
	$(CP) "$(PACKAGES_BUSYBOX_SRC_DIR)/examples/depmod.pl" $(PACKAGES_BUSYBOX_DEPMOD)

#Output build rule
${busybox.rules['build']}

#Output udhcpcd-script rule
${busybox.rules['udhcpc-script']}
	-$(MKDIR) $(ROOTFS_DIR)/etc/network
	$(CP) $(PACKAGES_BUSYBOX_SRC_DIR)/examples/udhcp/simple.script $(ROOTFS_DIR)/etc/network/udhcpc.script

#Output build install
${busybox.rules['install']}

#Simple rule written in pure Make syntax and just copied line for line into the
#final makefile
busybox-menuconfig:
	$(PACKAGES_ENV) $(MAKE) -C $(PACKAGES_BUSYBOX_BUILD_DIR) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(ARCH_TARGET)- menuconfig

#Add to targets
PACKAGES_BUILD_TARGETS += $(PACKAGES_BUSYBOX_BUILD)	
PACKAGES_INSTALL_TARGETS += $(PACKAGES_BUSYBOX_INSTALL)
PACKAGES_NAME_TARGETS += busybox

.NOTPARALLEL: