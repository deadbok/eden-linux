#mtl
MKDIR = mkdir -p $(VERBOSE_FLAG)

CP = cp $(VERBOSE_FLAG)

MV = mv $(VERBOSE_FLAG)

MAKE_PROCESSES = 1
MAKE_LOAD =
MAKE = make -j $(MAKE_PROCESSES) -l $(MAKE_LOAD)

TOUCH = touch $(VERBOSE_FLAG)

PATCH = patch $(VERBOSE_FLAG)

RM_PARAM = -f $(VERBOSE_FLAG)
RM = rm $(RM_PARAM)

LD = ld
LDFLAGS = "-Wl,-rpath,$(TOOLCHAIN_ROOT_DIR)/lib"

WGET = wget

TAR_PARAM = --touch
TAR = tar $(TAR_PARAM)