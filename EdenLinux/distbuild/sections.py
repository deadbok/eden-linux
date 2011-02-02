"""
Created on 16 Oct 2010

@author: oblivion
"""
import os.path
import shutil
import buildtree
from logger import logger
from makefile.makefile import Makefile
from makefile.makefile import MakefileSyntaxError
from makefile.template import Template
from makefile.builder import Builder
from makefile.builder import BuilderError

class sections(Builder):
    """Write the sections to makefiles"""
    def __init__(self, tree):
        """Constructor"""
        Builder.__init__(self, tree)

    def add_includes(self, node = None):
        try:
            if node == None:
                return
            #Include
            for include_file in self.get_node_include_files(node):
                #Do not include the current makefile
                if not include_file.replace("../", "") == self.makefile.filename.replace("build/", ""):
                    #Do not include if already included in another file
                    if include_file.find(node.name + ".mk") == -1:
                        path = self.tree.GetGlobalVar("root").GetDeref() + "/" + self.tree.GetGlobalVar("distbuild_dir").GetDeref()
                        path += self.tree2path(node.GetPath()[1:], True) + "/"
                        include_file = os.path.normpath(path + include_file)
                        if not include_file in self.included_files:
                            self.makefile.addInclude(include_file)
                            self.included_files.add(include_file)
        except MakefileSyntaxError as e:
            raise BuilderError("Syntax error: "
                               + e.msg + " in node "
                               + node.name + " value " + str(node.Get()))
        except SyntaxError as e:
            raise BuilderError("Syntax error: " + e.msg + " writing "
                                + self.makefile.filename)

    def write_var(self, node):
        """Create a make file with section global variables"""
        try:
            if node == None:
                return
            section = node
            for node in section.nodes.itervalues():
                if isinstance(node, buildtree.variable.Variable):
                    self.add_includes(node)
                    self.makefile.addVar(node.GetGlobalName("_").upper(),
                                         str(self.makefile.toMakeLine(node.Get())))
                    self.local_variables[node.name] = "$(" + node.GetGlobalName().replace(".", "_").upper() + ")"
        except MakefileSyntaxError as e:
            raise BuilderError("Syntax error: "
                               + e.msg + " in node: "
                               + node.name + " value: " + str(node.Get()))

    def write_dir(self, node):
        #Create a make file with rules to create the directories needed by the section
        if node == None:
            return
        section = node
        #Open the template makefile
        template = Template(self.tree.GetGlobalVar("template_dir").GetDeref()
                            + "/mkdir.mk")
        #Get all targets
        for node in section.IterNodes():
            if isinstance(node, buildtree.variable.Variable):
                if node.name.find("_dir") > -1:
                    #rule = template.combine({"target": "$(" + node.GetGlobalName().replace(".", "_").upper()
                    #                         + ")"})
                    #self.makefile.addTarget(rule[0], rule[1], rule[2])
                    template.combine(self.makefile,
                                     {"target": "$("
                                      + node.GetGlobalName().replace(".", "_").upper()
                                      + ")"})

    def write_target(self, node):
        #Write targets makefile
        if node == None:
            return
        try:
            section = node
            entry_targets = dict()
            for name, func in section.nodes.iteritems():
                if isinstance(func, buildtree.function.Function):
                    self.add_includes(func)
                    #Create a Makefile rule for the function
                    logger.debug("Converting function: "
                                 + str(func))
                    #Ignore the download function, if another package
                    #has downloaded the file
                    if ((name == "download") and
                        (section.GetLocalVar("url").GetDeref() in self.urls)):
                        logger.debug("Ignoring duplicate package url")
                    else:
                        self.local_variables["dependencies"] = ""
                        dependencies = func.GetLocalVar("func_dependencies", False)
                        if not dependencies == None:
                            self.local_variables["dependencies"] += dependencies.Get()
                        if not section.GetLocalVar("url", False) == None:
                            self.local_variables["packed_filename"] = os.path.basename(section.GetLocalVar("url").Get())
                            self.urls.add(section.GetLocalVar("url").GetDeref())
                        #directory to unpack the package to
                        if not section.parent == None:
                            self.local_variables["unpack_dir"] = ("$" + "{build_dir_" + section.parent.name + "}")
                            self.local_variables["current_package_dir"] = ("$" + "{build_dir_"
                                                            + section.parent.name + "}/"
                                                            + "$(DIR_"
                                                            + self.expand_name(node).upper()
                                                            + ")")
                            self.local_variables["package_file_dir"] = ("conf/"
                                                         + section.parent.name
                                                         + "/"
                                                         + section.name)
                        #Add target to local variables
                        if func.GetLocalVar("func_target", False) == None:
                            #Default target
                            self.local_variables["target"] = func.name + "_" + section.GetGlobalName("_")
                        else:
                            #Custom target
                            self.local_variables["target"] = func.GetLocalVar("func_target").Get()
                        #Create variables for local targets
                        entry_targets["current_" + func.name + "_target"] = self.local_variables["target"]
                        #Add function parameters to local variables
                        for func_node in func.IterNodes():
                            if func_node.name.find("func_") == -1:
                                if isinstance(func_node,
                                              buildtree.variable.Variable):
                                    self.local_variables[func_node.name] = func_node.Get()
                        #Add target variables for local targets, to local variables
                        self.local_variables.update(entry_targets)
                        try:
                            if not func.inline:
                                #Get template filename 
                                template_filename = func.GetLocalVar("func_makefile", False)
                                #If the template filename is empty supply a default template
                                if template_filename == None:
                                    section_names = func.GetPath()
                                    template_filename = (section_names[len(section_names) - 1] + "-" + func.name + ".mk")
                                else:
                                    template_filename = template_filename.GetDeref()
                                #Load the template
                                template = Template(self.tree.GetGlobalVar("template_dir").GetDeref()
                                                     + "/" + template_filename)
                                #Create rule from template
                                template.combine(self.makefile,
                                                 self.local_variables, None,
                                                 func.name.upper() + "_"
                                                + section.GetGlobalName("_").upper())
                            else:
                                template = Template()
                                template.combine(self.makefile,
                                                 self.local_variables,
                                                 func.code,
                                                 func.name.upper() + "_"
                                                + section.GetGlobalName("_").upper())
                        except IOError:
                            raise BuilderError("Error accessing template file "
                                               + template_filename
                                               + " in section "
                                               + section.name
                                               + ".")
                        except MakefileSyntaxError as e:
                            raise BuilderError("Template syntax error: "
                                               + e.msg + " in file: "
                                               + template_filename)
                        #Add rule to makefile
                        #self.makefile.addTarget(rule[0], rule[1], rule[2],
                        #                        func.name.upper() + "_"
                        #                        + section.GetGlobalName("_").upper())
                        #Clear function parameters from local variables
                        for func_node in func.IterNodes():
                            if func_node.name.find("func_") == -1:
                                if isinstance(func_node,
                                              buildtree.variable.Variable):
                                    del self.local_variables[func_node.name]
        except MakefileSyntaxError as e:
            raise BuilderError("Syntax error: "
                               + e.msg + " in node: "
                               + section.name + " value: "
                               + str(section.Get()))

    def write(self):
        """build the Makefiles for all sections"""
        logger.debug("Creating section Makefiles")
        #Run through the tree
        build_path = self.tree.GetGlobalVar("distbuild_dir").GetDeref()
        for node in self.tree.IterTree():
            #If this is a section
            if isinstance(node, buildtree.section.Section):

                path = build_path + self.tree2path(node.GetPath(), True)
                #Create directory for the Makefile
                try:
                    self.create_dir(path)
                    filename = path + "/" + node.name + ".mk"
                    self.makefile = Makefile(filename)
                    logger.debug("Creating makefile for section: " + node.name)
                    if node.name == "global":
                        self.makefile.addInclude(self.tree.GetGlobalVar("root").GetDeref() + "/" + build_path + "/rules.mk")
                    self.write_var(node)
                    #self.write_dir(node)
                    self.write_target(node)
                    if self.makefile.write():
                        logger.info('Writing: ' + filename + "...OK")
                except:
                    raise
        logger.info('Copying rules.mk...')
        shutil.copyfile(self.tree.GetGlobalVar("template_dir").GetDeref() + "/rules.mk",
                        build_path + "/rules.mk")


