"""
Created on Aug 29, 2010

@author: oblivion
"""
import os.path
from logger import logger
import buildtree.reference
from dependencies import Dependencies

class BuilderError(Exception):
    def __init__(self, msg = ""):
        Exception.__init__(self)
        self.msg = msg

    def __str__(self):
        return(self.msg)

class Builder(object):
    """Class of utility functions that help building a Makefile based build system from the buildtree"""
    dep = Dependencies()
    def __init__(self, tree):
        """Constructor"""
        logger.debug("Entering Builder.__init__")
        self.tree = tree
        makefile_path = self.tree.GetGlobalVar("distbuild_dir").GetDeref()
        self.create_dir(makefile_path)
        self.local_variables = dict()
        self.makefile = None
        self.included_files = set()
        self.urls = set()
        self.local_variables["dependencies"] = ""
        self.local_variables["target"] = ""
        self.local_variables["current_package_dir"] = ""
        self.dep.get(self.tree)

    def create_dir(self, directory):
        """Create directory if it does not exist"""
        if not os.path.exists(directory):
            logger.debug("Creating directory: " + directory)
            os.makedirs(directory)

    def tree2path(self, path, reverse = False):
        """Convert a path in the tree, to a path on the file system"""
        if path == None:
            return None
        rev_path = path
        if reverse:
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

    def get_node_include_files(self, node):
        """Get the include files, needed to full fill the dependencies of the
        node"""
        logger.debug("Getting include files from dependencies")
        if node == None:
            return("")
        ret = list()
        #Get dependencies for global variable references
        try:
            for reference in node.IterTree():
                if isinstance(reference, buildtree.reference.Reference):
                    if reference.reference in self.local_variables:
                        logger.debug(reference.reference + " found in local variables")
                    else:
                        logger.debug("Getting include file for reference: "
                                     + str(reference))
                        ref_node = reference.GetRef()
                        name = ref_node.GetGlobalName()
                        include_filenames = self.dep.dep_tree[name]
                        section = node
                        while not isinstance(section, buildtree.section.Section):
                            section = section.parent
                        if section.name in include_filenames:
                            include_filename = include_filenames[section.name]
                        else:
                            include_filename = ""
                            while not section.parent == None:
                                include_filename += "../"
                                section = section.parent
                            ref_sections = name.split(".")
                            if len(include_filenames) > 1:
                                include_filename += ref_sections[len(ref_sections) - 1] + "/" + include_filenames[ref_sections[len(ref_sections) - 1]]
                            else:
                                include_filename += include_filenames["global"]
                        if len(include_filename) > 0:
                            logger.debug("Including: " + include_filename)
                            if not include_filename in ret:
                                ret.append(include_filename)
        except SyntaxError as e:
            if e.filename == None:
                e.filename = " - " + self.makefile.filename
            e.filename += " - " + self.makefile.filename
            raise e
        except AttributeError:
            raise SyntaxError("Cannot find node " + reference.reference)
        return(ret)


    def get_section_include_files(self, node = None):
        """Get the include files, needed to full fill the dependencies of the
        section"""
        logger.debug("Getting include files from dependencies")
        if node == None:
            return(None)
        ret = list()
        try:
            for reference in node.IterSection():
                if isinstance(reference, buildtree.reference.Reference):
                    if reference.reference in self.local_variables:
                        logger.debug("Found in local variables")
                    else:
                        logger.debug("Getting include file for reference: "
                                     + str(reference))
                        ref_node = reference.GetRef()
                        name = ref_node.GetGlobalName()
                        include_filenames = self.dep.dep_tree[name]
                        if node.name in include_filenames:
                            include_filename = include_filenames[node.name]
                        else:
                            include_filename = ""
                        if len(include_filename) > 0:
                            logger.debug("Including: " + include_filename)
                            if not include_filename in ret:
                                ret.append(include_filename)
        except SyntaxError as e:
            if e.filename == None:
                e.filename = " - " + self.makefile.filename
            e.filename += " - " + self.makefile.filename
            raise e
        return(ret)
