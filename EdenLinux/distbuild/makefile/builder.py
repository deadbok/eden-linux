"""
Created on Aug 29, 2010

@author: oblivion
"""
import os.path
from logger import logger
import buildtree.reference
from makefile import Makefile

class BuilderError(Exception):
    def __init__(self, msg = ""):
        Exception.__init__()
        self.msg = msg

    def __str__(self):
        return(self.msg)

class Builder(object):
    """Class that builds a Makefile based build system from the buildtree"""
    def __init__(self, tree):
        """Constructor"""
        logger.debug("Entering Builder.__init__")
        self.tree = tree
        makefile_path = self.tree.GetGlobalVar("build_dir").GetDeref()
        self.create_dir(makefile_path)
        self.local_variables = dict()
        self.makefile = None

    def start(self, node, filename):
        self.makefile = Makefile(filename)


    def create_dir(self, directory):
        """Create directory if it does not exist"""
        if not os.path.exists(directory):
            logger.debug("Creating directory: " + directory)
            os.makedirs(directory)

    def tree2path(self, path):
        """Convert a path in the tree, to a path on the file system"""
        if path == None:
            return None
        rev_path = path
        rev_path.reverse()
        ret = ""
        for directory in rev_path:
            ret += "/" + directory
        return(ret)

    def expand_name(self, node = None, name = ""):
        """Add namespace to the variable, to get the global name"""
        if node == None:
            node = self.tree
        sections = ""
        for section_name in node.GetPath():
            if section_name != node.name:
                sections += "_"
            sections += section_name
        ret = ""
        if len(name) > 0:
            ret += name + "_"
        ret += sections
        return(ret)

    def get_section_include_files(self, node = None):
        """Get the include files, needed to full fill the dependencies of the
        section"""
        logger.debug("Getting include files from dependencies")
        if node == None:
            return(None)
        ret = list()
        #Get dependencies from the package if present
        dependencies = node.GetSection("dependencies")
        if not dependencies == None:
            for target in dependencies.nodes.itervalues():
                sections = ""
                target_sections = target.value.split("_")
                #Pop prefix of the target, to get only sections
                target_sections.pop(0)
                for section in reversed(target_sections):
                    sections += section + "/"
                ret.append(node.GetGlobalVar("root").GetDeref() + "/"
                           + node.GetGlobalVar("build_dir").GetDeref() + "/"
                           + sections + "*.mk")
                logger.debug("    Adding: "
                             + node.GetGlobalVar("root").GetDeref() + "/"
                             + node.GetGlobalVar("build_dir").GetDeref() + "/"
                             + sections + "*.mk")
                logger.debug("    For: " + target.name)
        #Get dependencies for global variables
        try:
            for reference in node.IterTree(node):
                if isinstance(reference, buildtree.reference.Reference):
                    if not reference.local:
                        if not reference.reference in self.local_variables:
                            logger.debug("Getting include file for reference: "
                                         + str(reference.Get()))
        except SyntaxError as e:
            e.filename = self.makefile.filename
            raise e
        return(ret)
