MODE=754
DIRMODE=755
CONFMODE=644
DESTDIR = .


#From: http://blog.jgc.org/2011/07/gnu-make-recursive-wildcard-function.html
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

ETC_FILES = $(call rwildcard,./etc,*)

$(DESTDIR)/etc/hosts: $(ETC_FILES)
	cp -R ./etc $(DESTDIR)
	chmod $(CONFMODE) $(DESTDIR)/etc/group
	chmod $(CONFMODE) $(DESTDIR)/etc/passwd	
	cp ./etc-templates/fstab $(DESTDIR)/etc/fstab
	sed -i 's:/dev/ROOT:$(ROOT_DEVICE):' $(DESTDIR)/etc/fstab
	sed -i 's:/dev/SWAP:$(SWAP_DEVICE):' $(DESTDIR)/etc/fstab
	echo "127.0.0.1 localhost" > $(DESTDIR)/etc/hosts
	ln -svf /proc/mounts $(DESTDIR)/etc/mtab
	#Add modules
	echo "modules=\"$(MODULES)\"" > $(DESTDIR)/etc/conf.d/modules

.PHONY: install
install: $(DESTDIR)/etc/hosts
	@echo "Baseconf installed."