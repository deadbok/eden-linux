download-all: build/dl/linux-2.6.30.tar.bz2 build/dl/gmp-4.3.1.tar.bz2

build/dl/linux-2.6.30.tar.bz2:
	wget ftp://ftp.dk.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2 -P build/dl


build/dl/gmp-4.3.1.tar.bz2:
	wget ftp://ftp.gmplib.org/pub/gmp-4.3.1/gmp-4.3.1.tar.bz2 -P build/dl


