"""
Created on 16 Oct 2010

@author: oblivion
"""
import buildtree
from logger import logger
from makefile.makefile import Makefile
from makefile.template import Template
from makefile.builder import Builder

class directories(Builder):
    """classdocs"""
    def __init__(self, tree):
        """Constructor"""
        Builder.__init__(self, tree)

    def write(self):
        """Create a makefile with rules to create the needed directories"""
        filename = (self.tree.GetGlobalVar("build_dir").GetDeref()
                    + "/directories.mk")
        self.start(self.tree, filename)
        #Open the template makefile
        template = Template(self.tree.GetGlobalVar("template_dir").GetDeref()
                                                     + "/mkdir.mk")
        #Get all targets
        for node in self.tree.IterNodes():
            if isinstance(node, buildtree.variable.Variable):
                if node.name.find("_dir") > -1:
                    rule = template.combine({"target": "$(" + node.name.upper() + ")"})
                    self.makefile.addTarget(rule[0], rule[1], rule[2])
        if not self.makefile.write():
            logger.info(filename + "...Already up to date.")
        else:
            logger.info('Writing: ' + filename + "...OK")
