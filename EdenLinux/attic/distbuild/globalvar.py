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

class globalvar(Builder):
    """classdocs"""
    def __init__(self, tree):
        """Constructor"""
        Builder.__init__(self, tree)

    def write(self):
        """Create a makefile holding all global variables."""
        filename = self.tree.GetGlobalVar("build_dir").GetDeref() + "/global.mk"
        self.start(self.tree, filename)
        #Write global variables
        try:
            for node in self.tree.nodes.itervalues():
                if isinstance(node, buildtree.variable.Variable):
                    self.makefile.addVar(node.name.upper(),
                                           str(self.makefile.toMakeLine(node.Get())))
        except MakefileSyntaxError as e:
            raise BuilderError("Syntax error: "
                               + e.msg + " in node: "
                               + node.name + " value: " + str(node.Get()))
        if not self.makefile.write():
            logger.info(filename + "...Already up to date.")
        else:
            logger.info('Writing: ' + filename + "...OK")
