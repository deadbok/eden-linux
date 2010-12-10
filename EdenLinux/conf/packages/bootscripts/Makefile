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
	#python $(DESTDIR)/sbin/rc-update.py --add mountroot --dir $(DESTDIR)/etc/rc.d
	

