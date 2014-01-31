#mtl

MKDIR = mkdir -p $(VERBOSE_FLAG)

CD = cd

CP = cp $(VERBOSE_FLAG)

RSYNC = rsync $(VERBOSE_FLAG)

CAT = cat

MV = mv $(VERBOSE_FLAG)

LN = ln  $(VERBOSE_FLAG)

MAKEFLAGS = -j $(MAKE_PROCESSES) -l $(MAKE_LOAD)

TOUCH = touch

PATCH = patch $(VERBOSE_FLAG)

RM_FLAGS = -f $(VERBOSE_FLAG)
RM = rm $(RM_FLAGS)

LD = ld

WGET = wget

TAR_FLAGS = --touch
TAR = tar $(TAR_FLAGS) $(VERBOSE_FLAG)

MKNOD = mknod

DD = dd

GENISOIMAGE = genisoimage $(VERBOSE_FLAG)

CHMOD = chmod $(VERBOSE_FLAG)
CHOWN = chown $(VERBOSE_FLAG)

GIT_FLAGS = 
GIT = git $(GIT_FLAGS)

PARTED = parted

LOSETUP = losetup

KPARTX = kpartx

MKFS_VFAT = mkfs.vfat
MKFS_EXT2 = mkfs.ext2
MKFS_EXT4 = mkfs.ext4

MOUNT = mount
UMOUNT = umount

ECHO = echo

FAKEROOT = fakeroot --