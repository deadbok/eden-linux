include build/globals.mk
include build/*.mk
include build/*/*.mk


all: $(GCC-STATIC_TOOLCHAIN)

.PHONY: source-clean $(TOOLCHAIN_CLEAN_TARGETS)
source-clean: $(TOOLCHAIN_CLEAN_TARGETS)

.PHONY: source-distclean $(TOOLCHAIN_DISTCLEAN_TARGETS)
source-distclean: $(TOOLCHAIN_DISTCLEAN_TARGETS)

