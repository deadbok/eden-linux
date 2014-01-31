#mtl
#THIS FILE IS RUN SEPERATLY AND SHOULD NOT BE INCLUDED IN ANYTHING ELSE.

include config.mk
include colors.mk
include commands.mk
include config.mk

ifdef  VERBOSE
export VERBOSE_FLAG = --verbose
else
export VERBOSE_FLAG =
endif

all: packages/pkg-list.mk

.PHONY: packages/pkg-list.mk
${Rule('packages/pkg-list.mk', dependencies='$(PACKAGE_LIST)')}
	$(TOUCH) $(ROOT)/packages/pkg-list.mk
	python2 $(ROOT)/host/pkgsolver/pkgsolver.py $(VERBOSE_FLAG) $(ROOT)/packages $(PACKAGE_LIST) pkg-list.mk