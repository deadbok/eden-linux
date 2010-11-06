'''
Created on 28 Oct 2010

@author: oblivion
'''

from logger import logger
import buildtree

class Dependencies(object):
    """Makefile dependency generation."""
    def __init__(self):
        """Constructor."""
        logger.debug("Entering Dependencies.__init__")
        self.dep_tree = dict()

    def get(self, tree):
        """Build dependency tree"""
        for node in tree.IterTree():
            if (isinstance(node, buildtree.variable.Variable) or
                isinstance(node, buildtree.function.Function)):
                path = node.GetGlobalName().split(".")
                #Remove the final node name
                if path[0].find("func") > -1:
                    path.pop(0)
                path.pop(0)
                path.append("global")
                filenames = dict()
                for i in range(len(path) - 1):
                    filenames[path[i + 1]] = path[i] + "/" + path[i] + ".mk"
                if len(filenames) == 0:
                    filenames["global"] = ""
                self.dep_tree[node.GetGlobalName()] = filenames
