#mtl
MKDIR = mkdir -p $(VERBOSE_FLAG)

CP = cp $(VERBOSE_FLAG)

CAT = cat

MV = mv $(VERBOSE_FLAG)

MAKE_PROCESSES = 1
MAKE_LOAD =
MAKEFLAGS = -j $(MAKE_PROCESSES) -l $(MAKE_LOAD)

TOUCH = touch $(VERBOSE_FLAG)

PATCH = patch $(VERBOSE_FLAG)

RM_FLAGS = -f $(VERBOSE_FLAG)
RM = rm $(RM_FLAGS)

LD = ld
LDFLAGS = "-Wl,-rpath,$(TOOLCHAIN_ROOT_DIR)/lib"

WGET = wget

TAR_FLAGS = --touch
TAR = tar $(TAR_FLAGS)

MKNOD = mknod

DD = dd

GENISOIMAGE = genisoimage $(VERBOSE_FLAG)

CHMOD = chmod