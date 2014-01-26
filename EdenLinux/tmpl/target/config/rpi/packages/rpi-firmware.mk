#mtl
${local_namespace("packages.rpi-firmware")}

#Rpi kernel package
${Package('$(DOWNLOAD_DIR)/firmware', '', 'x.y', "https://github.com/raspberrypi/firmware.git", "$(ROOTFS_DIR)/boot/start.elf")}

#Clone git repositry
${Rule('$(DOWNLOAD_DIR)/firmware/boot/start.elf', rule_var_name=var_name("clone"))}
	$(MKDIR) $(DOWNLOAD_DIR)/firmware
	$(GIT) clone --depth=1 $(PACKAGES_RPI-FIRMWARE_URL) $(DOWNLOAD_DIR)/firmware 

#Install files
${Rule('$(ROOTFS_DIR)/boot/start.elf', "$(PACKAGES_RPI-FIRMWARE_CLONE)", rule_var_name=var_name("install"))}
	$(CP) -R $(DOWNLOAD_DIR)/firmware/boot/{bootcode.bin,COPYING.linux,fixup_cd.dat,fixup.dat,fixup_x.dat,kernel_emergency.img,LICENCE.broadcom,start_cd.elf,start.elf,start_x.elf} $(ROOTFS_DIR)/boot/

PACKAGES_BOARD_INSTALL += $(PACKAGES_RPI-FIRMWARE_INSTALL)
PACKAGES_NAME_BOARD += ${namespace.current}

