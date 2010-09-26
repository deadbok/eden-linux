'''
Created on Aug 29, 2010

@author: oblivion
'''
import os.path
from logger import logger
import buildtree
from makefile import Makefile
from makefile import MakefileSyntaxError
from template import Template

class BuilderError(Exception):
    def __init__(self, msg = ""):
        Exception()
        self.msg = msg

    def __str__(self):
        return(self.msg)


class Builder(object):
    '''
    Class that builds a Makefile based build system from the buildtree 
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

    def TreetToFilePath(self, path):
        if path == None:
            return None
        rev_path = path
        rev_path.reverse()
        ret = ""
        for directory in rev_path:
            ret += "/" + directory
        return(ret)

    def global_mk(self):
        """Create a makefile holding all global variables."""
        filename = self.tree.GetGlobalVar("build_dir").GetDeref() + "/global.mk"
        logger.info('Creating: ' + filename)
        global_makefile = Makefile(filename)
        #Write global variables
        try:
            for node in self.tree.nodes.itervalues():
                if isinstance(node, buildtree.variable.Variable):
                    global_makefile.addVar(node.name.upper(),
                                           str(global_makefile.toMakeLine(node.Get())))
        except MakefileSyntaxError as e:
            raise BuilderError("Syntax error: "
                               + e.msg + " in node: "
                               + node.name + " value: " + str(node.Get()))

        logger.debug("Closing: " + filename)
        global_makefile.write()

    def directories_mk(self):
        """Create a makefile with rules to create the needed directories"""
        filename = (self.tree.GetGlobalVar("build_dir").GetDeref()
                    + "/directories.mk")
        logger.info('Creating: ' + filename)
        directories_makefile = Makefile(filename)

        #Open the template makefile
        template = Template(self.tree.GetGlobalVar("template_dir").GetDeref()
                                                     + "/mkdir.mk")
        #Get all targets
        for node in self.tree.IterNodes():
            if isinstance(node, buildtree.variable.Variable):
                if node.name.find("_dir") > -1:
                    rule = template.combine({"target": "$(" + node.name.upper() + ")"})
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
        template = Template(self.tree.getVar("template_dir",
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
        makefile.addInclude(self.tree.GetGlobalVar("build_dir").GetDeref()
                            + "/global.mk")
        makefile.addInclude(self.tree.GetGlobalVar("build_dir").GetDeref()
                            + "/*.mk")
        makefile.addInclude(self.tree.GetGlobalVar("build_dir").GetDeref()
                            + "/*/*.mk")
        dependencies = ""
        for node in self.tree.IterNodes():
            if isinstance(node, buildtree.section.Section):
                dependencies += " $(" + node.name.upper() + ")"
        makefile.addTarget("all", dependencies)
        makefile.addPhonyTarget("source-clean", "$(TOOLCHAIN_CLEAN_TARGETS)")
        makefile.addPhonyTarget("source-distclean", "$(TOOLCHAIN_DISTCLEAN_TARGETS)")
        makefile.write()

    def section_mk(self):
        """build the Makefiles for all sections"""
        logger.debug("Creating section Makefiles")
        section_targets = dict()

        for node in self.tree.IterTree():
            if (isinstance(node, buildtree.section.Section) and
                (node.name not in ["global", "build", "dependencies"])):
                path = self.tree.GetGlobalVar("build_dir").GetDeref()
                path += self.TreetToFilePath(node.GetPath())
                self.create_dir(path)
                logger.info("Creating: " + path + "/" + node.name + ".mk")
                makefile = Makefile(path + "/" + node.name + ".mk")
                #Include globals
#                makefile.addInclude(node.GetGlobalVar("root").GetDeref() + "/"
#                                    + node.GetGlobalVar("build_dir").GetDeref()
#                                    + "/" + node.parent.name + ".mk")
                makefile.addInclude(node.GetGlobalVar("root").GetDeref() + "/"
                                    + path + "/" + "*/*.mk", True)
                #Add variable to build the package and dependencies
                global_dependencies = ""
                sections = ""
                for section_name in node.GetPath():
                    if section_name != node.name:
                        sections += "_" + section_name
                dependencies = node.GetSection("dependencies")
                if not dependencies == None:
                    for target in dependencies.nodes.itervalues():
                        global_dependencies += (" $(" + target.value.upper() + sections.upper() + ")")
                        logger.debug("Adding dependency: " + target.value)
                makefile.addVar(node.name.upper() + sections.upper(),
                                global_dependencies +
                                " $(" + node.name.upper()
                                + sections.upper()
                                + "_INSTALL)")
                #Add local variables
                for var in node.IterNodes():
                    if isinstance(var, buildtree.variable.Variable):
                        makefile.addVar(node.name.upper() + sections.upper()
                                        + "_" + var.name.upper(),
                                        makefile.toMakeLine(var.Get(),
                                        node.name + sections))
                #Add function/rule
                build = node.GetSection("build")
                if not build == None:
                    #Get build sections and run through them
                    #Create a dictionary of all local targets
                    entry_targets = dict()
                    #Run through all functions in the build section
                    for name, func in build.nodes.iteritems():
                        if isinstance(func, buildtree.function.Function):
#                            Ignore download function, as it is taken care of
#                            if name == "download":
#                                logger.debug("Ignoring download function")
#                            else:
                                #Create a Makefile rule for the function
                            logger.debug("Converting function: "
                                         + str(func))
                            #Create a dict of local variables
                            _vars = dict()
                            _vars["packed_filename"] = os.path.basename(node.GetLocalVar("url").Get())
                            _vars["unpack_dir"] = ("$" + sections[1:len(sections)]
                                                  + "_build_dir")
                            _vars["current_package_dir"] = ("$"
                                                           + sections[1:len(sections)]
                                                           + "_build_dir/"
                                                           + "$("
                                                           + node.name.upper()
                                                           + sections.upper()
                                                           + "_DIR)")
                            _vars["package_file_dir"] = ("conf/" + sections[1:len(sections)]
                                                         + "/"
                                                         + node.name)
                            _vars["url"] = "$(url)"

                            dependencies = func.GetLocalVar("func_dependencies")
                            if dependencies == None:
                                _vars["dependencies"] = ""
                            else:
                                _vars["dependencies"] = dependencies.Get()
                            #Add target to local variables
                            if func.name.find("clean") > -1:
                                #Clean target
                                _vars["target"] = (node.name.upper()
                                                   + "_"
                                                   + sections[1:len(sections)].upper()
                                                   + "_"
                                                   + func.name.upper())
                            elif func.name.find("download") > -1:
                                #Download target
                                _vars["target"] = node.GetGlobalVar("download_dir").Get() + "/" + os.path.basename(node.GetLocalVar("url").Get())
                            elif func.GetLocalVar("func_target") == None:
                                #Default target
                                _vars["target"] = _vars["current_package_dir"] + "/." + func.name
                            else:
                                #Custom target
                                _vars["target"] = func.GetLocalVar("func_target").Get()

                            #Create variables for local targets
                            entry_targets["current_" + func.name + "_target"] = "$(" + (node.name + "_" + sections[1:len(sections)] + "_" + func.name).upper() + ")"

                            #Add function parameters to local variables
                            for func_node in func.IterNodes():
                                if func_node.name.find("func_") == -1:
                                    if isinstance(func_node, buildtree.variable.Variable):
                                        _vars[func_node.name] = func_node.Get()
                            #Add target variables for local targets, to local variables
                            _vars.update(entry_targets)
                            try:
                                #Get template filename 
                                template_filename = func.GetLocalVar("func_makefile")
                                #If the template filename is empty supply a default template
                                if template_filename == None:
                                    template_filename = (sections[1:len(sections)] + "-"
                                                         + func.name + ".mk")
                                else:
                                    template_filename = template_filename.GetDeref()
                                #Load the template
                                template = Template(node.GetGlobalVar("template_dir").GetDeref()
                                                     + "/" + template_filename)
                                #Create rule from template
                                rule = template.combine(_vars, node.name + sections)
                            except IOError:
                                raise BuilderError("Error during file access cannot continue")
                            except MakefileSyntaxError as e:
                                raise BuilderError("Template syntax error: "
                                                   + e.msg + " in file: "
                                                   + template_filename)

                            #Add rule to makefile
                            if func.name.find("clean") > -1:
                                makefile.addPhonyTarget(rule[0], rule[1], rule[2])
                            else:
                                makefile.addTarget(rule[0], rule[1], rule[2],
                                                   (node.name
                                                    + sections + "_"
                                                    + func.name).upper())
                            #Add target to section global target list
                            if not sections[1:len(sections)] in section_targets:
                                section_targets[sections[1:len(sections)]] = dict()
                            if not func.name in section_targets[sections[1:len(sections)]]:
                                section_targets[sections[1:len(sections)]][func.name] = ""
                            section_targets[sections[1:len(sections)]][func.name] += " " + rule[0]
                            #Add clean targets to section global target list                    
                #Write Makefile
                makefile.write()

#            logger.debug("Creating makefile for section: " + section_name)
#            makefile = Makefile(path + "/" + section_name + ".mk")
#            makefile.addInclude(self.tree.getVar("root") + "/"
#                                + self.tree.getVar("build_dir") + "/"
#                                + section_name + "/*/*.mk")
#            makefile.addVar(section_name.upper() + "_DIR", "$(BUILD_DIR)/" + section_name)
#            if section_name in section_targets:
#                for func_name in section_targets[section_name]:
#                    makefile.addVar(section_name.upper() + "_"
#                                    + func_name.upper() + "_TARGETS",
#                                    section_targets[section_name][func_name])
#            makefile.write()

    def build(self):
        """build the Makefiles from the buildtree"""
        logger.info("Creating Makefiles...")
        makefile_path = self.tree.GetGlobalVar("build_dir").GetDeref()
        self.create_dir(makefile_path)

        for node in self.tree.IterNodes():
            if isinstance(node, buildtree.section.Section):
                build_dir = self.tree.Add(buildtree.variable.Variable(node.name
                                                          + "_build_dir"))
                build_dir.Set(self.tree.GetGlobalVar("build_dir").Get()
                              + "/" + node.name + "_"
                              + node.GetGlobalVar("arch").Get()
                              + "_build")
        self.global_mk()
        self.directories_mk()
        #self.download_mk()
        self.section_mk()
        self.makefile()
