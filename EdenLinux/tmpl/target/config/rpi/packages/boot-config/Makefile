DESTDIR = .

$(DESTDIR)/boot/cmdline.txt:
	cp ./boot/cmdline.txt $(DESTDIR)/boot/cmdline.txt

$(DESTDIR)/boot/config.txt:
	cp ./boot/config.txt $(DESTDIR)/boot/config.txt

.PHONY: install
install: $(DESTDIR)/boot/cmdline.txt $(DESTDIR)/boot/config.txt
	@echo "Raspberry Pi boot configuration files installed."