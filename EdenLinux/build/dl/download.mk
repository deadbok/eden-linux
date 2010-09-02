include /home/oblivion/src/EdenLinux/build/globals.mk
download-all: $(DOWNLOAD_DIR)/linux-2.6.30.tar.bz2 $(DOWNLOAD_DIR)/gmp-4.3.1.tar.bz2

$(DOWNLOAD_DIR)/linux-2.6.30.tar.bz2:
	$(WGET) ftp://ftp.dk.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2 -P $(DOWNLOAD_DIR)


$(DOWNLOAD_DIR)/gmp-4.3.1.tar.bz2:
	$(WGET) ftp://ftp.gmplib.org/pub/gmp-4.3.1/gmp-4.3.1.tar.bz2 -P $(DOWNLOAD_DIR)


