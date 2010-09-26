include build/global.mk
include build/*.mk
include build/*/*.mk


all:  $(PACKAGES) $(TARGET) $(TOOLCHAIN)

.PHONY: source-clean $(TOOLCHAIN_CLEAN_TARGETS)
source-clean: $(TOOLCHAIN_CLEAN_TARGETS)

.PHONY: source-distclean $(TOOLCHAIN_DISTCLEAN_TARGETS)
source-distclean: $(TOOLCHAIN_DISTCLEAN_TARGETS)

