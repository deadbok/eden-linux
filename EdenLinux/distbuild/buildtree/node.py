"""
Created on Aug 25, 2010

@author: oblivion
"""
import os
import urlparse
from logger import logger

class Node(object):

    def __init__(self, root = None):
        """Constructor."""
        logger.debug("Entering Section.__init__")

        self.sections = dict()
        self.vars = dict()
        self.targets = list()
        self.functions = dict()
        self.root = root

    def parseVar(self, line, pos):
        i = pos
        ret = ""
        done = False
        while not done:
            i += 1
            if i == len(line):
                done = True
            else:
                if line[i].isalnum() or line[i] == "-" or line[i] == "_":
                    ret += line[i]
                else:
                    done = True

        return(ret, i)


    def expandVars(self, line, vars):
        """Replace variable names, with their values"""
        logger.debug("Expanding variables from globals...")
        i = line.find("$")
        var_name = ""
        logger.debug("Input string: " + line)

        if i > -1:
            ret = line[0:i]
            var_name, i = self.parseVar(line, i)

            logger.debug("Found variable: " + var_name.strip())
            if var_name.strip() in vars:
                value = vars[var_name.strip()]
                logger.debug("Value: " + value)
                ret += value
            else:
                logger.debug("Not in given dictionary")
                ret += "$" + var_name.strip()

            ret += self.expandVars(line[i:len(line)], vars)
        else:
            logger.debug("No variables")
            ret = line

        logger.debug("Expanded string: " + ret)
        return(ret)

        logger.debug("Converted string: " + ret)
        return(ret)

    def hasSection(self, name):
        if name in self.sections:
            return(True)
        else:
            return(False)

    def getSection(self, name):
        """Get a named section."""
        if name in self.sections:
            return(self.sections[name])
        else:
            logger.debug('Section "' + name + '" not found')

    def hasVar(self, name):
        if name in self.vars:
            return(True)
        else:
            return(False)

    def getVar(self, name, vars = None):
        """Get a named variable."""
        if name in self.vars:
            if not vars == None:
                return(self.expandVars(self.vars[name], vars))
            else:
                return(self.vars[name])
        else:
            logger.debug('Variable "' + name + '" not found')

    def getAllVar(self, name):
        """Get all variables of the name, from self, and every subsection."""
        var_dict = dict()

        for key, var in  self.sections.iteritems():
            for section in var:
                var_dict.update(section.getAllVar(name))

        if self.hasVar("name"):
            if self.hasVar("url"):
                var_dict[self.getVar("name")] = self.getVar("url")

        return(var_dict)

    def hasFunction(self, name):
        if name in self.functions:
            return(True)
        else:
            return(False)

    def getFunction(self, name):
        """Get a named function."""
        if name in self.functions:
            return(self.functions[name])
        else:
            logger.debug('Function "' + name + '" not found')

