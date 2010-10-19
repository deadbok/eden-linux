"""
Created on 16 Oct 2010

@author: oblivion
"""
import os.path
import buildtree
from logger import logger
from makefile.makefile import MakefileSyntaxError
from makefile.template import Template
from makefile.builder import Builder
from makefile.builder import BuilderError

class sections(Builder):
    """classdocs"""
    def __init__(self, tree):
        """Constructor"""
        Builder.__init__(self, tree)

    def write(self):
        """build the Makefiles for all sections"""
        logger.debug("Creating section Makefiles")
        section_targets = dict()
        urls = set()
        included_files = set()
        for node in self.tree.IterTree():
            #If this is a user defined section
            if (isinstance(node, buildtree.section.Section) and
                (node.name not in ["global", "build", "dependencies"])):
                path = self.tree.GetGlobalVar("build_dir").GetDeref()
                path += self.tree2path(node.GetPath())
                #Create director for the Makefile
                self.create_dir(path)
                filename = path + "/" + node.name + ".mk"
                self.start(self.tree, filename)
                #Include globals
                for include_file in self.get_section_include_files(node):
                    if not include_file in included_files:
                        self.makefile.addInclude(include_file)
                        included_files.add(include_file)
                #Add variable to build the package and dependencies
                global_dependencies = ""
                #Create section prefix
                sections = ""
                for section_name in node.GetPath():
                    if section_name != node.name:
                        sections += "_" + section_name
                dependencies = node.GetSection("dependencies")
                if not dependencies == None:
                    for target in dependencies.nodes.itervalues():
                        global_dependencies += (" $(" + target.value.upper()
                                                + ")")
                        logger.debug("Adding dependency: " + target.value)
                #Add local variables
                for var in node.IterNodes():
                    if isinstance(var, buildtree.variable.Variable):
                        self.makefile.addVar(self.expand_name(node, var.name).upper(),
                                        self.makefile.toMakeLine(var.Get(),
                                        self.expand_name(node)))
                #Add function/rule
                build = node.GetSection("build")
                if not build == None:
                    #Get build sections and run through them
                    #Create a dictionary of all local targets
                    entry_targets = dict()
                    #Run through all functions in the build section
                    for name, func in build.nodes.iteritems():
                        if isinstance(func, buildtree.function.Function):
                            #Ignore the download function, if another package
                            #has downloaded the file
                            if ((name == "download") and
                                (node.GetLocalVar("url").GetDeref() in urls)):
                                logger.debug("Ignoring duplicate download function")
                            else:
                                #Create a self.makefile rule for the function
                                logger.debug("Converting function: "
                                             + str(func))
                                #Create a dict of local variables
                                self.local_variables = dict()
                                self.local_variables["packed_filename"] = os.path.basename(node.GetLocalVar("url").Get())
                                self.local_variables["unpack_dir"] = ("$" + "build_dir_"
                                                        + sections[1:len(sections)] + "/")
                                self.local_variables["current_package_dir"] = ("$" + "build_dir_"
                                                                + sections[1:len(sections)] + "/"
                                                                + "$(DIR_"
                                                                + self.expand_name(node).upper()
                                                                + ")")
                                self.local_variables["package_file_dir"] = ("conf/" + sections[1:len(sections)]
                                                             + "/"
                                                             + node.name)
                                self.local_variables["dependencies"] = global_dependencies
                                dependencies = func.GetLocalVar("func_dependencies")
                                if not dependencies == None:
                                    self.local_variables["dependencies"] += dependencies.Get()
                                #Add target to local variables
                                if func.name.find("clean") > -1:
                                    #Clean target
                                    self.local_variables["target"] = (self.expand_name(node, func.name).upper())
                                elif func.name.find("download") > -1:
                                    #Download target
                                    self.local_variables["target"] = node.GetGlobalVar("download_dir").Get() + "/" + os.path.basename(node.GetLocalVar("url").Get())
                                elif func.GetLocalVar("func_target") == None:
                                    #Default target
                                    self.local_variables["target"] = self.local_variables["current_package_dir"] + "/." + func.name
                                else:
                                    #Custom target
                                    self.local_variables["target"] = func.GetLocalVar("func_target").Get()

                                #Create variables for local targets
                                entry_targets["current_" + func.name + "_target"] = "$(" + self.expand_name(node, func.name).upper() + ")"

                                #Add function parameters to local variables
                                for func_node in func.IterNodes():
                                    if func_node.name.find("func_") == -1:
                                        if isinstance(func_node, buildtree.variable.Variable):
                                            self.local_variables[func_node.name] = func_node.Get()
                                #Add target variables for local targets, to local variables
                                self.local_variables.update(entry_targets)
                                try:
                                    if not func.inline:
                                        #Get template filename 
                                        template_filename = func.GetLocalVar("func_makefile")
                                        #If the template filename is empty supply a default template
                                        if template_filename == None:
                                            template_filename = (sections[1:len(sections)] + "-"
                                                                 + func.name
                                                                 + ".mk")
                                        else:
                                            template_filename = template_filename.GetDeref()
                                        #Load the template
                                        template = Template(node.GetGlobalVar("template_dir").GetDeref()
                                                             + "/"
                                                             + template_filename)
                                        #Create rule from template
                                        rule = template.combine(self.local_variables, self.expand_name(node))
                                    else:
                                        template = Template()
                                        rule = template.combine(self.local_variables, self.expand_name(node), func.code)
                                except IOError:
                                    raise BuilderError("Error during file access cannot continue")
                                except MakefileSyntaxError as e:
                                    raise BuilderError("Template syntax error: "
                                                       + e.msg + " in file: "
                                                       + template_filename)

                                #Add rule to self.makefile
                                if func.name.find("clean") > -1:
                                    self.makefile.addPhonyTarget(rule[0], rule[1], rule[2])
                                else:
                                    self.makefile.addTarget(rule[0], rule[1], rule[2],
                                                       (self.expand_name(node, func.name).upper()))
                                #Add target to section global target list
                                if not sections[1:len(sections)] in section_targets:
                                    section_targets[sections[1:len(sections)]] = dict()
                                if not func.name in section_targets[sections[1:len(sections)]]:
                                    section_targets[sections[1:len(sections)]][func.name] = ""
                                section_targets[sections[1:len(sections)]][func.name] += " " + rule[0]
                                #Add clean targets to section global target list  
                    #Save the url in the set to check for duplicates later
                    urls.add(node.GetLocalVar("url").GetDeref())
                #Write self.makefile
                if not self.makefile.write():
                    logger.info(filename + "...Already up to date.")
                else:
                    logger.info('Writing: ' + filename + "...OK")
