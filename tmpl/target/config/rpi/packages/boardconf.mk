#mtl
${local_namespace("packages.boardconf")}

SERVICES += net.eth0

#Copy board specific config files
${Rule('board-config', '')}
	$(CP) -R $(ROOT)/target/config/rpi/packages/baseconf/* $(ROOTFS_DIR)/

#Create symlink for the first ehthernet device, need netifrc
${Rule('$(ROOTFS_DIR)/etc/init.d/net.eth0', '$(PACKAGES_BASE_NETIFRC_INSTALL)', rule_var_name = var_name('eth0-link'))}
	$(LN) -sf /etc/init.d/net.lo $(ROOTFS_DIR)/etc/init.d/net.eth0
	
.PHONY: $(${var_name('install')})
${Rule('ethernet-install', '$(PACKAGES_BOARDCONF_ETH0-LINK) board-config', rule_var_name = var_name('install'))}
	@echo For Raspberry Pi


#Add to targets
PACKAGES_BOARD_INSTALL += $(PACKAGES_BOARDCONF_INSTALL)
PACKAGES_NAME_BOARD += ${namespace.current}

.NOTPARALLEL: