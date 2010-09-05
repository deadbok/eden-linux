'''
Created on Aug 29, 2010

@author: oblivion
'''
import os
import os.path
from logger import logger
from makefilebuilder.makefile import Makefile
from makefilebuilder.makefiletemplate import MakefileTemplate

class Builder(object):
    '''
    classdocs
    '''
    def __init__(self, tree):
        '''
        Constructor
        '''
        logger.debug("Entering Builder.__init__")
        self.tree = tree
        self.globals = dict()

    def CreateDir(self, dir):
        """Create dir if it does not exist"""
        if not os.path.exists(dir):
            logger.debug("Creating directory: " + dir)
            os.makedirs(dir)

    def GlobalVars(self):
        """Create a dictionary of all global vars"""
        logger.debug("Processing global variables in buildtree...")

        #Write globals from root
        for name, value in self.tree.vars.iteritems():
            self.globals[name] = value
            logger.debug("Variable: " + name + " = " + value)

        #Write globals for all sections
        for name, var in self.tree.sections.iteritems():
            self.globals[name + "_build_dir"] = (self.tree.getVar("build_dir") +
                                                "/" + name + "_"
                                                + self.tree.getVar("arch"))
            logger.debug("Variable: " + name + "_build_dir" + " = "
                         + self.tree.getVar("build_dir") + "/" + name + "_"
                         + self.tree.getVar("arch"))

    def GlobalMK(self):
        """Create a Makefile holding all global variables."""
        filename = self.tree.getVar("build_dir", self.globals) + "/globals.mk"
        logger.info('Creating: ' + filename)
        global_mk = Makefile(filename)
        #Write global variables
        for name, var in self.globals.iteritems():
            global_mk.addVar(name.upper(), str(global_mk.toMakeLine(var)))

        logger.debug("Closing: " + filename)
        global_mk.write()

    def DownloadMK(self):
        """Create a Makefile with rules to download all needed files."""
        download_dir = self.tree.getVar("download_dir", self.globals)

        logger.info('Creating: ' + download_dir + "/download.mk")

        self.CreateDir(download_dir)
        #Create file

        download_mk = Makefile(download_dir + "/download.mk")
        download_mk.addInclude(self.tree.getVar("root") + "/"
                               + self.tree.getVar("build_dir")
                               + "/globals.mk")

        #Get all urls in the buildtree
        urls = set(self.tree.getAllVar("url").values())

        #Create a target for downloading all files
        all_targets = ""
        for target in urls:
            all_targets += " $(DOWNLOAD_DIR)/" + os.path.basename(target)

        download_mk.addTarget("download-all", all_targets)

        #Open the template Makefile
        template = MakefileTemplate(self.tree.getVar("template_dir",
                                                     self.globals)
                                    + "/download.mk")

        #Get all urls and targets
        vars = dict()
        for url in urls:
            vars.update({"url": url, "target": ("$(DOWNLOAD_DIR)/"
                                                + os.path.basename(url))})

            rule = template.combine(vars)
            download_mk.addTarget(rule[0], rule[1], rule[2])

        download_mk.write()

    def Makefile(self):
        """Create the global Makefile"""
        logger.info('Creating: Makefile')

        makefile = Makefile("Makefile")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/*.mk")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/*/*.mk")
        makefile.write()

    def SectionMK(self):
        """Build the Makefiles for all sections"""
        logger.debug("Creating section directories")
        for section_name, section in self.tree.sections.iteritems():
            path = self.tree.getVar("build_dir", self.globals) + "/" + section_name
            for entry in section:
                self.CreateDir(path + "/" + entry.getVar("name"))
                makefile = Makefile(path + "/" + entry.getVar("name") + "/" + entry.getVar("name") + ".mk")

                #Include globals
                makefile.addInclude(self.tree.getVar("root") + "/"
                           + self.tree.getVar("build_dir")
                           + "/globals.mk")

                #Add local variables
                for name, value in entry.vars.iteritems():
                    makefile.addVar(name.upper(), value)
                #Write Makefile
                makefile.write()

    def Build(self):
        """Build the Makefiles from the buildtree"""
        logger.info("Creating Makefiles...")
        makefile_path = self.tree.getVar("build_dir")
        self.CreateDir(makefile_path)

        #Get all global variables
        self.GlobalVars()
        self.GlobalMK()
        self.DownloadMK()
        self.SectionMK()
        self.Makefile()
