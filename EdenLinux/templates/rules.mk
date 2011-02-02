%.dir:
	mkdir -p $(dir $@)
	touch $@

ifdef $(VERBOSE)
VERBOSE_FLAG = --verbose
else
VERBOSE_FLAG =
endif