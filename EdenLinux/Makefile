EPYDOC = epydoc-2.7

ifdef VERBOSE
VERBOSE_FLAG = --verbose
else
VERBOSE_FLAG =
endif

ifdef DEBUG
LOG_LEVEL = --log-level=0
else
LOG_LEVEL = 
endif

all:
	./mtl/mtl.py $(LOG_LEVEL) tmpl build
	$(MAKE) -C build all MAKE_PROCESSES=2
	
install:
	$(MAKE) -C build install MAKE_PROCESSES=2
	
html-doc:
	mkdir -p mtl/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph=all --html --include-log --output mtl/doc/html mtl
	mkdir -p plugins/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph=all --html --include-log --output plugins/doc/html plugins	