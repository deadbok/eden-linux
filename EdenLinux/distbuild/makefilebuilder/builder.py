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

    def create_dir(self, directory):
        """Create directory if it does not exist"""
        if not os.path.exists(directory):
            logger.debug("Creating directory: " + directory)
            os.makedirs(directory)

    def global_vars(self):
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

    def globals_mk(self):
        """Create a Makefile holding all global variables."""
        filename = self.tree.getVar("build_dir", self.globals) + "/globals.mk"
        logger.info('Creating: ' + filename)
        global_makefile = Makefile(filename)
        #Write global variables
        for name, var in self.globals.iteritems():
            global_makefile.addVar(name.upper(), str(global_makefile.toMakeLine(var)))

        logger.debug("Closing: " + filename)
        global_makefile.write()

    def directories_mk(self):
        """Create a Makefile with rules to create the needed directories"""
        filename = self.tree.getVar("build_dir", self.globals) + "/directories.mk"
        logger.info('Creating: ' + filename)
        directories_makefile = Makefile(filename)

        #Open the template Makefile
        template = MakefileTemplate(self.tree.getVar("template_dir",
                                                     self.globals)
                                                     + "/mkdir.mk")

        #Get all targets
        vars = dict()
        for name, value in self.globals.iteritems():
            if name.find("_dir") > -1:
                vars.update({"target": value})
                rule = template.combine(vars)
                directories_makefile.addTarget(rule[0], rule[1], rule[2])

        directories_makefile.write()

    def download_mk(self):
        """Create a Makefile with rules to download all needed files."""
        download_dir = self.tree.getVar("download_dir", self.globals)

        logger.info('Creating: ' + download_dir + "/download.mk")

        self.create_dir(download_dir)
        #Create file
        download = Makefile(download_dir + "/download.mk")
        download.addInclude(self.tree.getVar("root") + "/"
                               + self.tree.getVar("build_dir")
                               + "/globals.mk")

        #Get all urls in the buildtree
        urls = set(self.tree.getAllVar("url").values())

        #Create a target for downloading all files
        all_targets = ""
        for target in urls:
            all_targets += " $(DOWNLOAD_DIR)/" + os.path.basename(target)
        download.addTarget("download-all", all_targets)

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
            download.addTarget(rule[0], rule[1], rule[2])

        download.write()

    def Makefile(self):
        """Create the global Makefile"""
        logger.info('Creating: Makefile')

        makefile = Makefile("Makefile")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/globals.mk")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/*.mk")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/*/*.mk")

        makefile.addTarget("all", "$(TOOLCHAIN_TARGETS)")
        makefile.write()

    def SectionMK(self):
        """Build the Makefiles for all sections"""
        logger.debug("Creating section directories")
        section_targets = dict()
        for section_name, section in self.tree.sections.iteritems():
            path = (self.tree.getVar("build_dir", self.globals)
                    + "/" + section_name)
            for entry in section:
                self.create_dir(path + "/" + entry.getVar("name"))
                logger.info("Creating: " + path + "/" + entry.getVar("name")
                            + "/" + entry.getVar("name") + ".mk")
                makefile = Makefile(path + "/" + entry.getVar("name") + "/"
                                    + entry.getVar("name") + ".mk")

                #Include globals
                makefile.addInclude(self.tree.getVar("root") + "/"
                           + self.tree.getVar("build_dir")
                           + "/globals.mk")

                #Add local variables
                for name, value in entry.vars.iteritems():
                    makefile.addVar(entry.getVar("name").upper() + "_"
                                    + name.upper(), makefile.toMakeLine(value, entry.getVar("name")))

                #Add function/rule
                if entry.hasSection("build"):
                    build_sections = entry.getSection("build")
                    for build in build_sections:
                        entry_targets = dict()
                        for name, func in build.functions.iteritems():
                            #Ignore download function, as it is taken care of
                            if name == "download":
                                logger.debug("Ignoring download function")
                            elif name == "unpack":
                                packed_filename = os.path.basename(entry.getVar("url"))
                                logger.debug("Creating decompression rule for: "
                                             + packed_filename)
                                entry_targets["current_unpack_target"] = func.target

                                vars = dict()
                                vars["packed_filename"] = packed_filename
                                vars["unpack_dir"] = "$" + section_name + "_build_dir/"
                                vars["current_package_dir"] = ("$"
                                                               + section_name
                                                               + "_build_dir/"
                                                               + "$("
                                                               + entry.getVar("name").upper()
                                                               + "_DIR)")
                                if func.target == "":
                                    vars["target"] = vars["current_package_dir"] + "/.unpacked"
                                else:
                                    vars["target"] = func.target
                                template = MakefileTemplate(self.tree.getVar("template_dir",
                                                                             self.globals)
                                                                             + "/unpack.mk")
                                rule = template.combine(vars, entry.getVar("name"))
                                makefile.addTarget(rule[0], rule[1], rule[2])
                                entry_targets["current_unpack_target"] = vars["target"]
                            else:
                                logger.debug("Converting function: " + str(func))
                                vars = dict()
                                vars["packed_filename"] = os.path.basename(entry.getVar("url"))
                                vars["unpack_dir"] = "$" + section_name + "_build_dir/"
                                vars["current_package_dir"] = ("$"
                                                               + section_name
                                                               + "_build_dir/"
                                                               + "$("
                                                               + entry.getVar("name").upper()
                                                               + "_DIR)")
                                if func.target == "":
                                    vars["target"] = vars["current_package_dir"] + "/." + func.name
                                else:
                                    vars["target"] = func.target
                                entry_targets["current_" + func.name + "_target"] = "$(" + (entry.getVar("name") + "_" + section_name + "_" + func.name).upper() + ")"
                                vars.update(func.param)
                                vars.update(entry_targets)
                                template_filename = func.file
                                if template_filename == "":
                                    template_filename = func.name + ".mk"
                                template = MakefileTemplate(self.tree.getVar("template_dir",
                                                     self.globals)
                                                     + "/" + template_filename)

                                rule = template.combine(vars, entry.getVar("name"))
                                makefile.addTarget(rule[0], rule[1], rule[2], (entry.getVar("name") + "_" + section_name + "_" + func.name).upper())
                                if name == "install":
                                    if not section_name in section_targets:
                                        section_targets[section_name] = ""
                                    section_targets[section_name] += " " + makefile.toMakeLine(func.target)
                #Write Makefile
                makefile.write()

            logger.debug("Creating Makefile for section: " + section_name)
            makefile = Makefile(path + "/" + section_name + ".mk")
            makefile.addInclude(self.tree.getVar("root") + "/"
                                + self.tree.getVar("build_dir") + "/"
                                + section_name + "/*/*.mk")

            if section_name in section_targets:
                makefile.addVar(section_name.upper() + "_TARGETS", section_targets[section_name])
            makefile.write()

    def Build(self):
        """Build the Makefiles from the buildtree"""
        logger.info("Creating Makefiles...")
        makefile_path = self.tree.getVar("build_dir")
        self.create_dir(makefile_path)

        #Get all global variables
        self.global_vars()
        self.globals_mk()
        self.directories_mk()
        self.download_mk()
        self.SectionMK()
        self.Makefile()
