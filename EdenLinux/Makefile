EPYDOC = epydoc
MKDIR = mkdir -p

ifdef  VERBOSE
export VERBOSE_FLAG = --verbose
else
export VERBOSE_FLAG =
endif

ifdef DEBUG
LOG_LEVEL = --log-level=0
else
LOG_LEVEL = 
endif

#From: http://blog.jgc.org/2011/07/gnu-make-recursive-wildcard-function.html
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

TMPL_FILES = $(call rwildcard,tmpl,*)

BUILDSYS_DIR = build

all: $(BUILDSYS_DIR)/.mtlstamp
	$(MAKE) -C build all 2>&1 | tee build.log 

buildsys: $(BUILDSYS_DIR)/.mtlstamp
	@echo "Buildsys done. Files in: ./$(BUILDSYS_DIR)"
	
install:
	$(MAKE) -C build install 2>&1 | tee install.log 
	
html-doc:
	mkdir -p mtl/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph=all --html --include-log --output mtl/doc/html mtl
	mkdir -p plugins/doc/html
	$(EPYDOC) $(VERBOSE_FLAG) --graph=all --html --include-log --output plugins/doc/html plugins

$(BUILDSYS_DIR):
	$(MKDIR) build

$(BUILDSYS_DIR)/.mtlstamp: $(BUILDSYS_DIR) $(TMPL_FILES)
	python2 ./mtl/mtl.py $(LOG_LEVEL) tmpl $(BUILDSYS_DIR)
	touch $@

.PHONY: makefiles
makefiles: $(BUILDSYS_DIR)/.mtlstamp

%:
	$(MAKE) -C build $@
