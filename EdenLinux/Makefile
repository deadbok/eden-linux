EPYDOC = epydoc

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

#From: http://blog.jgc.org/2011/07/gnu-make-recursive-wildcard-function.html
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

TMPL_FILES = $(call rwildcard,tmpl,*)
MTL_FILES = $(call rwildcard,mtl,*.py) $(call rwildcard,plugins,*.py)

BUILDSYS_DIR = build

all: $(BUILDSYS_DIR)/.mtlstamp
	$(MAKE) -C build all 2>&1 | tee build.log 
	
install:
	$(MAKE) -C build install 2>&1 | tee install.log 
	
html-doc:
	mkdir -p mtl/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph all --html --include-log --output mtl/doc/html mtl
	mkdir -p plugins/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph all --html --include-log --output plugins/doc/html plugins
	mkdir -p config/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph all --html --include-log --output config/doc/html config

$(BUILDSYS_DIR)/.mtlstamp: $(TMPL_FILES) $(MTL_FILES)
	./mtl/mtl.py $(LOG_LEVEL) . $(BUILDSYS_DIR)
	touch $@

.PHONY: makefiles
makefiles: $(BUILDSYS_DIR)/.mtlstamp

%:
	$(MAKE) -C build $@
