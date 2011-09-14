MODE=754
DIRMODE=755
CONFMODE=644
DESTDIR = .

install:
	cp -R ./etc $(DESTDIR)
	chmod $(CONFMODE) $(DESTDIR)/etc/group
	chmod $(CONFMODE) $(DESTDIR)/etc/passwd	
	cp ./etc-templates/fstab $(DESTDIR)/etc/fstab
	sed -i 's:/dev/ROOT:$(ROOT_DEVICE):' $(DESTDIR)/etc/fstab
	sed -i 's:/dev/SWAP:$(SWAP_DEVICE):' $(DESTDIR)/etc/fstab
	echo "127.0.0.1 localhost" > $(DESTDIR)/etc/hosts
	ln -svf /proc/mounts $(DESTDIR)/etc/mtab
