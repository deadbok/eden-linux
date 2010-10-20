MODE=754
DIRMODE=755
CONFMODE=644

DESTDIR = .
#/etc
$(DESTDIR)/etc:
	mkdir -p $(DESTDIR)/etc
	
$(DESTDIR)/etc/rc.d/init.d/functions: $(DESTDIR)/etc
	cp -R $(VERBOSE_FLAG) $(PACKAGE_DIR)/skel/etc/* $(DESTDIR)/etc/.
	rm -Rf $(VERBOSE_FLAG) $(DESTDIR)/etc/rc.d/init.d/.svn
	rm -Rf $(VERBOSE_FLAG) $(DESTDIR)/etc/rc.d/.svn

.PHONY permissions: $(DESTDIR)/etc/rc.d/init.d/functions
permissions:
	chmod -R $(DIRMODE) $(DESTDIR)/etc/rc.d
	chmod $(CONFMODE) $(DESTDIR)/etc/rc.d/init.d/functions
	chmod $(MODE) $(DESTDIR)/etc/rc.d/startup
	chmod $(MODE) $(DESTDIR)/etc/rc.d/shutdown
	chmod $(MODE) $(DESTDIR)/etc/rc.d/init.d/network
	chmod $(MODE) $(DESTDIR)/etc/rc.d/init.d/syslog
	chmod $(MODE) $(DESTDIR)/etc/rc.d/init.d/udev
	chmod $(MODE) $(DESTDIR)/etc/rc.d/init.d/modules
	chmod $(MODE) $(DESTDIR)/etc/rc.d/init.d/mountroot
	
.PHONY links: $(DESTDIR)/etc/rc.d/init.d/functions
links:
	ln -sf ../init.d/udev $(DESTDIR)/etc/rc.d/start/S01udev
	ln -sf ../init.d/udev $(DESTDIR)/etc/rc.d/stop/K90udev
	ln -sf ../init.d/syslog $(DESTDIR)/etc/rc.d/start/S09syslog
	ln -sf ../init.d/syslog $(DESTDIR)/etc/rc.d/stop/K99syslog
	ln -sf ../init.d/modules $(DESTDIR)/etc/rc.d/start/S05modules
	ln -sf ../init.d/modules $(DESTDIR)/etc/rc.d/stop/K95modules	
	ln -sf ../init.d/network $(DESTDIR)/etc/rc.d/start/S10network
	ln -sf ../init.d/network $(DESTDIR)/etc/rc.d/stop/K80network
	ln -sf ../init.d/network $(DESTDIR)/etc/rc.d/start/S06mountroot
	
$(DESTDIR)/etc/hostname: $(DESTDIR)/etc $(ROOT)/Makefile
	echo $(EDEN_HOSTNAME) > $(DESTDIR)/etc/hostname
	
$(DESTDIR)/etc/hosts: $(DESTDIR)/etc $(ROOT)/Makefile
	echo "127.0.0.1 localhost $(EDEN_HOSTNAME).$(EDEN_DOMAINNAME)" > $(DESTDIR)/etc/hosts

$(DESTDIR)/etc/fstab.tmp: $(PACKAGE_DIR)/skel/etc-templates/fstab $(ROOT)/Makefile
	sed 's:/dev/ROOT:$(EDEN_ROOT_DEVICE):' $(PACKAGE_DIR)/skel/etc-templates/fstab > $(DESTDIR)/etc/fstab.tmp

$(DESTDIR)/etc/fstab: $(DESTDIR)/etc/fstab.tmp
	sed 's:/dev/SWAP:$(EDEN_SWAP_DEVICE):' $(DESTDIR)/etc/fstab.tmp > $(DESTDIR)/etc/fstab
	rm -f $(VERBOSE_FLAG) $(DESTDIR)/etc/fstab.tmp

$(DESTDIR)/etc/mtab:	
	ln -svf /proc/mounts $(DESTDIR)/etc/mtab

$(DESTDIR)/etc/network: $(DESTDIR)/etc	
	mkdir -p $(DESTDIR)/etc/network
	
$(DESTDIR)/etc/network/interface.eth0: $(DESTDIR)/etc/network
	echo "INTERFACE=eth0" > $(DESTDIR)/etc/network/interface.eth0
	echo "DHCP=yes" >> $(DESTDIR)/etc/network/interface.eth0
	echo "#IPADDRESS=192.168.1.10" >> $(DESTDIR)/etc/network.d/interface.eth0
	echo "#NETMASK=255.255.255.0" >> $(DESTDIR)/etc/network.d/interface.eth0
	echo "#BROADCAST=192.168.1.255" >> $(DESTDIR)/etc/network.d/interface.eth0

network: $(DESTDIR)/etc/network/interface.eth0
	
etc: $(DESTDIR)/etc/rc.d/init.d/functions $(DESTDIR)/etc/hostname $(DESTDIR)/etc/hosts $(DESTDIR)/etc/fstab $(DESTDIR)/etc/mtab network permissions links

#/dev
$(DESTDIR)/dev: udev-target
	mkdir -p $(DESTDIR)/dev
	
$(DESTDIR)/dev/pts:	
	mkdir -p $(DESTDIR)/dev/pts
	chown root:root $(DESTDIR)/dev/pts
	
$(DESTDIR)/dev/zero: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/zero c 1 5
	
$(DESTDIR)/dev/null: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/null c 1 3
	
$(DESTDIR)/dev/tty: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/tty c 5 0
		
$(DESTDIR)/dev/console: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/console c 5 1
	
$(DESTDIR)/dev/ptmx: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/ptmx c 5 2
	
$(DESTDIR)/dev/tty0: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/tty0 c 4 0
	
$(DESTDIR)/dev/tty1: $(DESTDIR)/dev
	mknod $(DESTDIR)/dev/tty1 c 4 1
		
dev: $(DESTDIR)/dev/pts $(DESTDIR)/dev/zero $(DESTDIR)/dev/null $(DESTDIR)/dev/tty $(DESTDIR)/dev/console $(DESTDIR)/dev/ptmx $(DESTDIR)/dev/tty0 $(DESTDIR)/dev/tty1
	touch $(DESTDIR)/dev/*

dev-clean:
	rm -f $(VERBOSE_FLAG) $(DESTDIR)/dev/zero $(DESTDIR)/dev/null $(DESTDIR)/dev/tty $(DESTDIR)/dev/console $(DESTDIR)/dev/ptmx $(DESTDIR)/dev/tty0 $( )/dev/tty1 

dev-distclean: dev-clean

#/var
$(DESTDIR)/var/run:
	mkdir -p $(DESTDIR)/var/run

$(DESTDIR)/var/run/utmp: $(DESTDIR)/var/run
	touch $(DESTDIR)/var/run/utmp
	chmod -v 664 $(DESTDIR)/var/run/utmp
	
$(DESTDIR)/var/log:
	mkdir -p $(DESTDIR)/var/log 

$(DESTDIR)/var/log/btmp: $(DESTDIR)/var/log
	touch $(DESTDIR)/var/log/btmp

$(DESTDIR)/var/log/lastlog: $(DESTDIR)/var/log
	touch $(DESTDIR)/var/log/lastlog
	chmod -v 664 $(DESTDIR)/var/log/lastlog
	
$(DESTDIR)/var/log/wtmp: $(DESTDIR)/var/log
	touch $(DESTDIR)/var/log/wtmp

var: $(DESTDIR)/var/run/utmp $(DESTDIR)/var/log/btmp $(DESTDIR)/var/log/lastlog $(DESTDIR)/var/log/wtmp

#All together now
all: etc var

install: dev

clean:
	rm -fR $(DESTDIR)/etc $(DESTDIR)/dev $(DESTDIR)/var
