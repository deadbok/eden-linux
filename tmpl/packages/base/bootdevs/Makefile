DESTDIR = .

$(DESTDIR)/dev:
	mkdir -p $(DESTDIR)/dev
	
$(DESTDIR)/dev/pts:	
	mkdir -p $(DESTDIR)/dev/pts
	chown root:root $(DESTDIR)/dev/pts
	
$(DESTDIR)/dev/zero: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/zero c 1 5
	
$(DESTDIR)/dev/null: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/null c 1 3
	
$(DESTDIR)/dev/tty: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty c 5 0
		
$(DESTDIR)/dev/console: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/console c 5 1
	
$(DESTDIR)/dev/ptmx: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/ptmx c 5 2
	
$(DESTDIR)/dev/tty0: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty0 c 4 0
	
$(DESTDIR)/dev/tty1: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty1 c 4 1

$(DESTDIR)/dev/tty2: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty2 c 4 2
	
$(DESTDIR)/dev/tty3: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty3 c 4 3
	
$(DESTDIR)/dev/tty4: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty4 c 4 4
	
$(DESTDIR)/dev/tty5: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty5 c 4 5
	
$(DESTDIR)/dev/tty6: $(DESTDIR)/dev
	-mknod $(DESTDIR)/dev/tty6 c 4 6

$(DESTDIR)/dev/rtc: $(DESTDIR)/dev	
	-mknod $(DESTDIR)/dev/rtc c 10 135
	
DEVICES += $(DESTDIR)/dev/pts $(DESTDIR)/dev/zero $(DESTDIR)/dev/null $(DESTDIR)/dev/tty 
DEVICES += $(DESTDIR)/dev/console $(DESTDIR)/dev/ptmx $(DESTDIR)/dev/tty0 $(DESTDIR)/dev/tty1
DEVICES += $(DESTDIR)/dev/tty2 $(DESTDIR)/dev/tty3 $(DESTDIR)/dev/tty4 $(DESTDIR)/dev/tty5
DEVICES += $(DESTDIR)/dev/tty6 $(DESTDIR)/dev/rtc 

dev: $(DEVICES) 
	touch $(DESTDIR)/dev/*

dev-clean:
	rm -f $(VERBOSE_FLAG) $(DEVICES) 

dev-distclean: dev-clean
	
install: dev
