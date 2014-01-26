#mtl
${local_namespace("packages.boardconf")}

SERVICES += net.eth0

#Create symlink for the first ehthernet device
${Rule('$(ROOTFS_DIR)/etc/init.d/net.eth0', rule_var_name = var_name('eth0-link'))}
	$(LN) -sf /etc/init.d/net.lo $(ROOTFS_DIR)/etc/init.d/net.eth0
	
.PHONY: $(${var_name('install')})
${Rule('ethernel-install', '$(PACKAGES_BOARDCONF_ETH0-LINK)', rule_var_name = var_name('install'))}


#Add to targets
PACKAGES_BOARD_INSTALL += $(PACKAGES_BOARDCONF_INSTALL)
PACKAGES_NAME_BOARD += ${namespace.current}

.NOTPARALLEL: