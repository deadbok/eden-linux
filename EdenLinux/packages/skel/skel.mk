MODE=754
DIRMODE=755
CONFMODE=644

#/etc
$(ROOTFS)/etc:
	mkdir -p $(ROOTFS)/etc
	
$(ROOTFS)/etc/rc.d/init.d/functions: $(ROOTFS)/etc
	cp -R $(VERBOSE_FLAG) $(PACKAGE_DIR)/skel/etc/* $(ROOTFS)/etc/.
	rm -Rf $(VERBOSE_FLAG) $(ROOTFS)/etc/rc.d/init.d/.svn
	rm -Rf $(VERBOSE_FLAG) $(ROOTFS)/etc/rc.d/.svn

.PHONY permissions: $(ROOTFS)/etc/rc.d/init.d/functions
permissions:
	chmod -R $(DIRMODE) $(ROOTFS)/etc/rc.d
	chmod $(CONFMODE) $(ROOTFS)/etc/rc.d/init.d/functions
	chmod $(MODE) $(ROOTFS)/etc/rc.d/startup
	chmod $(MODE) $(ROOTFS)/etc/rc.d/shutdown
	chmod $(MODE) $(ROOTFS)/etc/rc.d/init.d/network
	chmod $(MODE) $(ROOTFS)/etc/rc.d/init.d/syslog
	chmod $(MODE) $(ROOTFS)/etc/rc.d/init.d/udev
	chmod $(MODE) $(ROOTFS)/etc/rc.d/init.d/modules
	chmod $(MODE) $(ROOTFS)/etc/rc.d/init.d/mountroot
	
.PHONY links: $(ROOTFS)/etc/rc.d/init.d/functions
links:
	ln -sf ../init.d/udev $(ROOTFS)/etc/rc.d/start/S01udev
	ln -sf ../init.d/udev $(ROOTFS)/etc/rc.d/stop/K90udev
	ln -sf ../init.d/syslog $(ROOTFS)/etc/rc.d/start/S09syslog
	ln -sf ../init.d/syslog $(ROOTFS)/etc/rc.d/stop/K99syslog
	ln -sf ../init.d/modules $(ROOTFS)/etc/rc.d/start/S05modules
	ln -sf ../init.d/modules $(ROOTFS)/etc/rc.d/stop/K95modules	
	ln -sf ../init.d/network $(ROOTFS)/etc/rc.d/start/S10network
	ln -sf ../init.d/network $(ROOTFS)/etc/rc.d/stop/K80network
	ln -sf ../init.d/network $(ROOTFS)/etc/rc.d/start/S06mountroot
	
$(ROOTFS)/etc/hostname: $(ROOTFS)/etc $(ROOT)/Makefile
	echo $(EDEN_HOSTNAME) > $(ROOTFS)/etc/hostname
	
$(ROOTFS)/etc/hosts: $(ROOTFS)/etc $(ROOT)/Makefile
	echo "127.0.0.1 localhost $(EDEN_HOSTNAME).$(EDEN_DOMAINNAME)" > $(ROOTFS)/etc/hosts

$(ROOTFS)/etc/fstab.tmp: $(PACKAGE_DIR)/skel/etc-templates/fstab $(ROOT)/Makefile
	sed 's:/dev/ROOT:$(EDEN_ROOT_DEVICE):' $(PACKAGE_DIR)/skel/etc-templates/fstab > $(ROOTFS)/etc/fstab.tmp

$(ROOTFS)/etc/fstab: $(ROOTFS)/etc/fstab.tmp
	sed 's:/dev/SWAP:$(EDEN_SWAP_DEVICE):' $(ROOTFS)/etc/fstab.tmp > $(ROOTFS)/etc/fstab
	rm -f $(VERBOSE_FLAG) $(ROOTFS)/etc/fstab.tmp

$(ROOTFS)/etc/mtab:	
	ln -svf /proc/mounts $(ROOTFS)/etc/mtab

$(ROOTFS)/etc/network: $(ROOTFS)/etc	
	mkdir -p $(ROOTFS)/etc/network
	
$(ROOTFS)/etc/network/interface.eth0: $(ROOTFS)/etc/network
	echo "INTERFACE=eth0" > $(ROOTFS)/etc/network/interface.eth0
	echo "DHCP=yes" >> $(ROOTFS)/etc/network/interface.eth0
	echo "#IPADDRESS=192.168.1.10" >> $(ROOTFS)/etc/network.d/interface.eth0
	echo "#NETMASK=255.255.255.0" >> $(ROOTFS)/etc/network.d/interface.eth0
	echo "#BROADCAST=192.168.1.255" >> $(ROOTFS)/etc/network.d/interface.eth0

network: $(ROOTFS)/etc/network/interface.eth0
	
etc: $(ROOTFS)/etc/rc.d/init.d/functions $(ROOTFS)/etc/hostname $(ROOTFS)/etc/hosts $(ROOTFS)/etc/fstab $(ROOTFS)/etc/mtab network permissions links

#/dev
$(ROOTFS)/dev: udev-target
	mkdir -p $(ROOTFS)/dev
	
$(ROOTFS)/dev/pts:	
	mkdir -p $(ROOTFS)/dev/pts
	chown root:root $(ROOTFS)/dev/pts
	
$(ROOTFS)/dev/zero: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/zero c 1 5
	
$(ROOTFS)/dev/null: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/null c 1 3
	
$(ROOTFS)/dev/tty: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/tty c 5 0
		
$(ROOTFS)/dev/console: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/console c 5 1
	
$(ROOTFS)/dev/ptmx: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/ptmx c 5 2
	
$(ROOTFS)/dev/tty0: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/tty0 c 4 0
	
$(ROOTFS)/dev/tty1: $(ROOTFS)/dev
	mknod $(ROOTFS)/dev/tty1 c 4 1
		
dev: $(ROOTFS)/dev/pts $(ROOTFS)/dev/zero $(ROOTFS)/dev/null $(ROOTFS)/dev/tty $(ROOTFS)/dev/console $(ROOTFS)/dev/ptmx $(ROOTFS)/dev/tty0 $(ROOTFS)/dev/tty1
	touch $(ROOTFS)/dev/*

dev-clean:
	rm -f $(VERBOSE_FLAG) $(ROOTFS)/dev/zero $(ROOTFS)/dev/null $(ROOTFS)/dev/tty $(ROOTFS)/dev/console $(ROOTFS)/dev/ptmx $(ROOTFS)/dev/tty0 $( )/dev/tty1 

dev-distclean: dev-clean

#/var
$(ROOTFS)/var/run:
	mkdir -p $(ROOTFS)/var/run

$(ROOTFS)/var/run/utmp: $(ROOTFS)/var/run
	touch $(ROOTFS)/var/run/utmp
	chmod -v 664 $(ROOTFS)/var/run/utmp
	
$(ROOTFS)/var/log:
	mkdir -p $(ROOTFS)/var/log 

$(ROOTFS)/var/log/btmp: $(ROOTFS)/var/log
	touch $(ROOTFS)/var/log/btmp

$(ROOTFS)/var/log/lastlog: $(ROOTFS)/var/log
	touch $(ROOTFS)/var/log/lastlog
	chmod -v 664 $(ROOTFS)/var/log/lastlog
	
$(ROOTFS)/var/log/wtmp: $(ROOTFS)/var/log
	touch $(ROOTFS)/var/log/wtmp

var: $(ROOTFS)/var/run/utmp $(ROOTFS)/var/log/btmp $(ROOTFS)/var/log/lastlog $(ROOTFS)/var/log/wtmp

#All together now
skel: etc var

skel-install: dev

skel-clean:
	rm -fR $(ROOTFS)/etc $(ROOTFS)/dev $(ROOTFS)/var

skel-distclean: skel-clean dev-distclean
	
TARGETS += skel 
INSTALL_TARGETS += skel-install
CLEAN_TARGETS += skel-clean
DISTCLEAN_TARGTETS += skel-distclean 
