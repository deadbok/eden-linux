$(EDEN_IMAGE_FILE): $(IMAGE_DIR)
	dd if=/dev/zero of=$(EDEN_IMAGE_FILE) bs=1M count=$(EDEN_IMAGE_SIZE)

vbox: ext2	
	rm -f $(basename $(EDEN_IMAGE_FILE)).vdi
	VBoxManage convertdd $(EDEN_IMAGE_FILE) $(basename $(EDEN_IMAGE_FILE)).vdi
	chown root:users $(basename $(EDEN_IMAGE_FILE)).vdi
	chmod 0666 $(basename $(EDEN_IMAGE_FILE)).vdi

$(basename $(EDEN_IMAGE_FILE)).vmdk: ext2	
	qemu-img convert -O vmdk $(EDEN_IMAGE_FILE) $(basename $(EDEN_IMAGE_FILE)).vmdk
	chown root:users $(basename $(EDEN_IMAGE_FILE)).vmdk
	chmod 0666 $(basename $(EDEN_IMAGE_FILE)).vmdk

$(IMAGE_DIR)/EdenLinux.vmx: $(basename $(EDEN_IMAGE_FILE)).vmdk
	$(CP) $(TARGETS_DIR)/vmware/EdenLinux.vmx $(IMAGE_DIR)/EdenLinux.vmx
	chmod 0666 $(IMAGE_DIR)/EdenLinux.vmx
	
.PHONY: vmware
vmware: $(IMAGE_DIR)/EdenLinux.vmx
	
