'''
Created on Aug 25, 2010

@author: oblivion
'''
import os
import urlparse
from logger import logger

class Node(dict):
    """
    name = linux-kernel
    version = 2.6.30
    url = ftp://ftp.dk.kernel.org/pub/linux/kernel/v2.6/linux-2.6.30.tar.bz2
    
    build:
        download()
        unpack()
        config()
        build()
        install()
    """

    def __init__(self):
        logger.debug("Entering Section.__init__")
        dict.__init__(self)

        self.section = dict()
        self.var = dict()
        self.target = list()
        self.function = dict()

    def download(self):
        if os.path.exists("download-" + self.name + ".mk"):
            self.download_script = "download-" + self.name + ".mk"
        else:
            self.download_script = "download.mk"
        logger.info("Download script: " + self.download_script)

    def unpack(self):
        split_url = urlparse.urlsplit(self.url)
        self.archive_type = (os.path.splitext(split_url[2]))[1].replace(".", "")

        if os.path.exists("unpack-" + self.name + ".mk"):
            self.unpack_script = "unpack-" + self.name + ".mk"
        else:
            self.unpack_script = "unpack-" + self.archive_type
        logger.info("Unpack script: " + self.unpack_script)

    def config(self):
        if os.path.exists("config-" + self.name + ".mk"):
            self.config_script = "config-" + self.name + ".mk"
        else:
            self.config_script = "config.mk"
        logger.info("Config script: " + self.config_script)

    def build(self):
        if os.path.exists("build-" + self.name + ".mk"):
            self.build_script = "build-" + self.name + ".mk"
        else:
            self.build_script = "build.mk"
        logger.info("Build script: " + self.config_script)

    def install(self):
        if os.path.exists("install-" + self.name + ".mk"):
            self.install_script = "install-" + self.name + ".mk"
        else:
            self.install_script = "install.mk"
        logger.info("Install script: " + self.config_script)
