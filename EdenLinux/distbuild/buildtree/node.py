"""
Created on Aug 25, 2010

@author: oblivion
"""
import os
import urlparse
from logger import logger

class Node(object):

    def __init__(self, root = None):
        """Constructor."""
        logger.debug("Entering Section.__init__")

        self.sections = dict()
        self.vars = dict()
        self.targets = list()
        self.functions = dict()
        self.root = root

    def hasSection(self, name):
        if name in self.sections:
            return(True)
        else:
            return(False)

    def getSection(self, name):
        """Get a named section."""
        if name in self.sections:
            return(self.sections[name])
        else:
            logger.debug('Section "' + name + '" not found')

    def hasVar(self, name):
        if name in self.vars:
            return(True)
        else:
            return(False)

    def getVar(self, name):
        """Get a named variable."""
        if name in self.vars:
            return(self.vars[name])
        else:
            logger.debug('Variable "' + name + '" not found')

    def getAllVar(self, name):
        """Get all variables of the name, from self, and every subsection."""
        var_dict = dict()

        for key, var in  self.sections.iteritems():
            for section in var:
                var_dict.update(section.getAllVar(name))

        if self.hasVar("name"):
            if self.hasVar("url"):
                var_dict[self.getVar("name")] = self.getVar("url")

        return(var_dict)

    def hasFunction(self, name):
        if name in self.functions:
            return(True)
        else:
            return(False)

    def getFunction(self, name):
        """Get a named function."""
        if name in self.functions:
            return(self.functions[name])
        else:
            logger.debug('Function "' + name + '" not found')

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
