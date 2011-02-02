MODE=754
DIRMODE=755
CONFMODE=644
DESTDIR = .

install:
	cp -R ./etc $(DESTDIR)
	chmod -R $(DIRMODE) $(DESTDIR)/etc/rc.d
	chmod $(CONFMODE) $(DESTDIR)/etc/rc.d/functions
	chmod $(MODE) $(DESTDIR)/etc/rc.d/startup
	chmod $(MODE) $(DESTDIR)/etc/rc.d/shutdown
	chmod $(MODE) $(DESTDIR)/etc/init.d/*
	cp -R ./sbin $(DESTDIR)
	touch $(DESTDIR)/etc/rc.d/start_services
	touch $(DESTDIR)/etc/rc.d/stop_services	
	python $(DESTDIR)/sbin/rc-update.py --add syslog --dir $(DESTDIR)/etc
	python $(DESTDIR)/sbin/rc-update.py --add clock --dir $(DESTDIR)/etc	
	python $(DESTDIR)/sbin/rc-update.py --add mountroot --dir $(DESTDIR)/etc
	python $(DESTDIR)/sbin/rc-update.py --add udev --dir $(DESTDIR)/etc
	python $(DESTDIR)/sbin/rc-update.py --add network --dir $(DESTDIR)/etc	

