"""
Created on 16 Oct 2010

@author: oblivion
"""
import buildtree
from logger import logger
from makefile.makefile import Makefile
from makefile.makefile import MakefileSyntaxError
from makefile.builder import Builder
from makefile.builder import BuilderError
from makefile.template import Template

class build(Builder):
    """reate a makefile for all global targets"""
    def __init__(self, tree):
        """Constructor"""
        Builder.__init__(self, tree)

    def write(self):
        """Create a makefile with the global targets."""
        filename = self.tree.GetGlobalVar("build_dir").GetDeref() + "/build.mk"
        self.start(self.tree, filename)
        #Write global targets
        try:
            build = self.tree.GetSection("build")
            if not build == None:
                #Get build sections and run through them
                #Create a dictionary of all local targets
                entry_targets = dict()
                #Run through all functions in the build section
                for name, func in build.nodes.iteritems():
                    if isinstance(func, buildtree.function.Function):
                        #Create a Makefile rule for the function
                        logger.debug("Converting function: "
                                     + str(func))
                        #Create a dict of local variables
                        _vars = dict()
                        dependencies = func.GetLocalVar("func_dependencies")
                        if not dependencies == None:
                            _vars["dependencies"] += dependencies.Get()
                        #Add target to local variables
                        if func.GetLocalVar("func_target") == None:
                            #Default target
                            _vars["target"] = func.name
                        else:
                            #Custom target
                            _vars["target"] = func.GetLocalVar("func_target").Get()

                        #Create variables for local targets
                        entry_targets["current_" + func.name + "_target"] = "$(" + func.name + ")"
                        #Add function parameters to local variables
                        for func_node in func.IterNodes():
                            if func_node.name.find("func_") == -1:
                                if isinstance(func_node, buildtree.variable.Variable):
                                    _vars[func_node.name] = func_node.Get()
                        #Add target variables for local targets, to local variables
                        _vars.update(entry_targets)
                        try:
                            if not func.inline:
                                #Get template filename 
                                template_filename = func.GetLocalVar("func_makefile")
                                #If the template filename is empty supply a default template
                                if template_filename == None:
                                    template_filename = (func.name + ".mk")
                                else:
                                    template_filename = template_filename.GetDeref()
                                #Load the template
                                template = Template(self.tree.GetGlobalVar("template_dir").GetDeref()
                                                     + "/" + template_filename)
                                #Create rule from template
                                rule = template.combine(_vars)
                            else:
                                template = Template()
                                rule = template.combine(_vars, "", func.code)
                        except IOError:
                            raise BuilderError("Error during file access cannot continue")
                        except MakefileSyntaxError as e:
                            raise BuilderError("Template syntax error: "
                                               + e.msg + " in file: "
                                               + template_filename)

                        #Add rule to makefile
                        if func.name.find("clean") > -1:
                            self.makefile.addPhonyTarget(rule[0], rule[1], rule[2])
                        else:
                            self.makefile.addTarget(rule[0], rule[1], rule[2])
        except MakefileSyntaxError as e:
            raise BuilderError("Syntax error: "
                               + e.msg + " in node: "
                               + build.name + " value: " + str(build.Get()))
        logger.debug("Closing: " + filename)
        if not self.makefile.write():
            logger.info(filename + "...Already up to date.")
        else:
            logger.info('Writing: ' + filename + "...OK")
