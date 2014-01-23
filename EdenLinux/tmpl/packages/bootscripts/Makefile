MODE=754
DIRMODE=755
CONFMODE=644
DESTDIR = 


SRC =  $(shell pwd)/src

install: $(DESTDIR)/etc/inittab
#install: $(DESTDIR)/etc/rc.d/startup $(DESTDIR)/etc/rc.d/start_services $(DESTDIR)/etc/rc.d/stop_services

#From: http://blog.jgc.org/2011/07/gnu-make-recursive-wildcard-function.html
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

ETC_FILES = $(call rwildcard,./etc,*)

$(DESTDIR)/etc/inittab:
	cp ./etc/inittab $(DESTDIR)/etc/
	
#$(DESTDIR)/etc/rc.d/startup: $(ETC_FILES)
#	cp -R ./etc $(DESTDIR)
#	chmod -R $(DIRMODE) $(DESTDIR)/etc/rc.d
#	chmod $(CONFMODE) $(DESTDIR)/etc/rc.d/functions
#	chmod $(MODE) $(DESTDIR)/etc/rc.d/startup
#	chmod $(MODE) $(DESTDIR)/etc/rc.d/shutdown
#	chmod $(MODE) $(DESTDIR)/etc/init.d/*

#$(DESTDIR)/etc/rc.d:
#	mkdir -p $(DESTDIR)/etc/rc.d
	
#$(DESTDIR)/etc/rc.d/start_services: $(DESTDIR)/etc/rc.d	
#	touch $(DESTDIR)/etc/rc.d/start_services

#$(DESTDIR)/etc/rc.d/stop_services: $(DESTDIR)/etc/rc.d
#	touch $(DESTDIR)/etc/rc.d/stop_services	
