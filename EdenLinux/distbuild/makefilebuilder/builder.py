'''
Created on Aug 29, 2010

@author: oblivion
'''
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

    def create_dir(self, directory):
        """Create directory if it does not exist"""
        if not os.path.exists(directory):
            logger.debug("Creating directory: " + directory)
            os.makedirs(directory)

    def globals_mk(self):
        """Create a makefile holding all global variables."""
        filename = str(self.tree.GetGlobalVar("build_dir")) + "/globals.mk"
        logger.info('Creating: ' + filename)
        global_makefile = Makefile(filename)
        #Write global variables
        for name, var in self.globals.iteritems():
            global_makefile.addVar(name.upper(),
                                   str(global_makefile.toMakeLine(var)))

        logger.debug("Closing: " + filename)
        global_makefile.write()

    def directories_mk(self):
        """Create a makefile with rules to create the needed directories"""
        filename = (self.tree.getVar("build_dir", self.globals)
                    + "/directories.mk")
        logger.info('Creating: ' + filename)
        directories_makefile = Makefile(filename)

        #Open the template makefile
        template = MakefileTemplate(self.tree.getVar("template_dir",
                                                     self.globals)
                                                     + "/mkdir.mk")

        #Get all targets
        _vars = dict()
        for name, value in self.globals.iteritems():
            if name.find("_dir") > -1:
                _vars.update({"target": value})
                rule = template.combine(_vars)
                directories_makefile.addTarget(rule[0], rule[1], rule[2])

        directories_makefile.write()

    def download_mk(self):
        """Create a makefile with rules to download all needed files."""
        download_dir = self.tree.getVar("download_dir", self.globals)

        logger.info('Creating: ' + download_dir + "/download.mk")
        #Create download dir
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

        #Open the template makefile
        template = MakefileTemplate(self.tree.getVar("template_dir",
                                                     self.globals)
                                    + "/download.mk")

        #Get all urls and targets
        _vars = dict()
        for url in urls:
            _vars.update({"url": download.toMakeLine(url), "target": ("$(DOWNLOAD_DIR)/"
                                                + os.path.basename(url))})
            rule = template.combine(_vars)
            download.addTarget(rule[0], rule[1], rule[2])

        download.write()

    def makefile(self):
        """Create the global makefile"""
        logger.info('Creating: Makefile')

        makefile = Makefile("Makefile")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/globals.mk")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/*.mk")
        makefile.addInclude(self.tree.getVar("build_dir", self.globals)
                            + "/*/*.mk")

        makefile.addTarget("all", "$(GCC-CROSS_TOOLCHAIN)")
        makefile.addPhonyTarget("source-clean", "$(TOOLCHAIN_CLEAN_TARGETS)")
        makefile.addPhonyTarget("source-distclean", "$(TOOLCHAIN_DISTCLEAN_TARGETS)")
        makefile.write()

    def section_mk(self):
        """build the Makefiles for all sections"""
        logger.debug("Creating section directories")
        section_targets = dict()

        node = self.tree
        while

        for section_name, section in self.tree.sections.iteritems():
            path = (str(self.tree.GetGlobalVar("build_dir"))
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
                #Add variable to build the package and dependencies
                global_dependencies = ""
                if entry.hasSection("dependencies"):
                    for dependency in entry.getSection("dependencies"):
                        for target in dependency.targets:
                            global_dependencies += (" $(" + target.upper() + "_" + section_name.upper() + ")")
                            logger.debug("Adding dependency: "
                             + target)
                makefile.addVar(entry.getVar("name").upper() + "_"
                                + section_name.upper(),
                                global_dependencies +
                                " $(" + entry.getVar("name").upper() + "_"
                                + section_name.upper()
                                + "_INSTALL)")
                #Add local variables
                for name, value in entry.vars.iteritems():
                    makefile.addVar(entry.getVar("name").upper() + "_"
                                    + name.upper(),
                                    makefile.toMakeLine(value,
                                                        entry.getVar("name")))
                #Add function/rule
                if entry.hasSection("build"):
                    #Get build sections and run through them
                    for build in entry.getSection("build"):
                        #Create a dictionary of all local targets
                        entry_targets = dict()
                        #Run through all functions in the build section
                        for name, func in build.functions.iteritems():
                            #Ignore download function, as it is taken care of
#                            if name == "download":
#                                logger.debug("Ignoring download function")
                            #else:
                                #Create a Makefile rule for the function
                            logger.debug("Converting function: "
                                         + str(func))
                            #Create a dict of local variables
                            _vars = dict()
                            _vars["packed_filename"] = os.path.basename(entry.getVar("url"))
                            _vars["unpack_dir"] = ("$" + section_name
                                                  + "_build_dir")
                            _vars["current_package_dir"] = ("$"
                                                           + section_name
                                                           + "_build_dir/"
                                                           + "$("
                                                           + entry.getVar("name").upper()
                                                           + "_DIR)")
                            _vars["package_file_dir"] = ("conf/" + section_name
                                                         + "/"
                                                         + entry.getVar("name"))
                            _vars["url"] = "$(url)"

                            _vars["dependencies"] = func.dependencies
                            #Add target to local variables
                            if func.name.find("clean") > -1:
                                #Clean target
                                _vars["target"] = (entry.getVar("name").upper()
                                                   + "_"
                                                   + section_name.upper()
                                                   + "_"
                                                   + func.name.upper())
                            elif func.name.find("download") > -1:
                                #Download target
                                _vars["target"] = self.tree.getVar("download_dir") + "/" + os.path.basename(entry.getVar("url"))
                            elif func.target == "":
                                #Default target
                                _vars["target"] = _vars["current_package_dir"] + "/." + func.name
                            else:
                                #Custom target
                                _vars["target"] = func.target

                            #Create variables for local targets
                            entry_targets["current_" + func.name + "_target"] = "$(" + (entry.getVar("name") + "_" + section_name + "_" + func.name).upper() + ")"

                            #Add function parameters to local variables
                            _vars.update(func.param)
                            #Add target variables for local targets, to local variables
                            _vars.update(entry_targets)
                            #Get template filename 
                            template_filename = func.file
                            #If the template filename is empty supply a default template
                            if template_filename == "":
                                template_filename = section_name + "-" + func.name + ".mk"
                            #Load the template
                            template = MakefileTemplate(self.tree.getVar("template_dir",
                                                 self.globals)
                                                 + "/" + template_filename)
                            #Create rule from template
                            rule = template.combine(_vars, entry.getVar("name"))
                            #Add rule to makefile
                            if func.name.find("clean") > -1:
                                makefile.addPhonyTarget(rule[0], rule[1], rule[2])
                            else:
                                makefile.addTarget(rule[0], rule[1], rule[2],
                                                   (entry.getVar("name") + "_"
                                                    + section_name + "_"
                                                    + func.name).upper())
                            #Add target to section global target list
                            if not section_name in section_targets:
                                section_targets[section_name] = dict()
                            if not func.name in section_targets[section_name]:
                                section_targets[section_name][func.name] = ""
                            section_targets[section_name][func.name] += " " + rule[0]
                            #Add clean targets to section global target list                    
                #Write Makefile
                makefile.write()

            logger.debug("Creating makefile for section: " + section_name)
            makefile = Makefile(path + "/" + section_name + ".mk")
            makefile.addInclude(self.tree.getVar("root") + "/"
                                + self.tree.getVar("build_dir") + "/"
                                + section_name + "/*/*.mk")
            makefile.addVar(section_name.upper() + "_DIR", "$(BUILD_DIR)/" + section_name)
            if section_name in section_targets:
                for func_name in section_targets[section_name]:
                    makefile.addVar(section_name.upper() + "_"
                                    + func_name.upper() + "_TARGETS",
                                    section_targets[section_name][func_name])
            makefile.write()

    def build(self):
        """build the Makefiles from the buildtree"""
        logger.info("Creating Makefiles...")
        makefile_path = self.tree.getVar("build_dir")
        self.create_dir(makefile_path)

        #Get all global variables
        self.global_vars()

        self.globals_mk()
        self.directories_mk()
        #self.download_mk()
        self.section_mk()
        self.makefile()
