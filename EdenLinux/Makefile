-include build/global.mk

#This is only the first target if the above files whre not found
ifndef DISTBUILD_DIR
all:
ifdef DEBUG
	distbuild/distbuild.py -l0 conf
else
	distbuild/distbuild.py conf
endif
	$(MAKE) all #| tee build.log
endif

.PHONY: distclean
distclean:
	$(MAKE) -C distbuild/docs clean
	$(RM) -R $(BUILD_DIR)
	
.PHONY: docs
docs:
	$(MAKE) -C distbuild/docs html
