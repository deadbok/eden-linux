MODE=754
DIRMODE=755
CONFMODE=644
DESTDIR = 


SRC =  $(shell pwd)/src
ifdef DEBUG
GO = $(CROSS_COMPILE)gccgo -g
else
GO = $(CROSS_COMPILE)gccgo
endif

$(SRC)/rc-update: $(SRC)/rc-update.go
	$(GO) $(SRC)/rc-update.go -o $(SRC)/rc-update
	
all: $(SRC)/rc-update

$(DESTDIR)/sbin/rc-update: $(SRC)/rc-update
	install -D $(SRC)/rc-update $(DESTDIR)/sbin/rc-update

install: .installed $(DESTDIR)/etc/rc.d/start_services $(DESTDIR)/etc/rc.d/stop_services


.installed: $(DESTDIR)/sbin/rc-update
	cp -R ./etc $(DESTDIR)
	chmod -R $(DIRMODE) $(DESTDIR)/etc/rc.d
	chmod $(CONFMODE) $(DESTDIR)/etc/rc.d/functions
	chmod $(MODE) $(DESTDIR)/etc/rc.d/startup
	chmod $(MODE) $(DESTDIR)/etc/rc.d/shutdown
	chmod $(MODE) $(DESTDIR)/etc/init.d/*
	touch .installed

$(DESTDIR)/etc/rc.d:
	mkdir -p $(DESTDIR)/etc/rc.d
	
$(DESTDIR)/etc/rc.d/start_services:	$(DESTDIR)/etc/rc.d
	touch $(DESTDIR)/etc/rc.d/start_services

$(DESTDIR)/etc/rc.d/stop_services: $(DESTDIR)/etc/rc.d
	touch $(DESTDIR)/etc/rc.d/stop_services	
