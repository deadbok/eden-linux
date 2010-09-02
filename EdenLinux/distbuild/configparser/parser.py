'''
Created on Aug 25, 2010

@author: oblivion
'''
import os
from logger import logger
from buildtree.node import Node
from buildtree.function import Function

class Parser(object):
    def __init__(self, root = None):
        """Constructor"""
        logger.debug("Entering Parser.__init__")

        self.tree = Node(root)

    def parseVariable(self, lines):
        """Parse a variable from a config file"""
        logger.debug("Parsing variable.")

        var = lines[0].strip().partition("=")
        logger.debug("Variable: " + var[0] + " = " + var[2])
        del lines[0]
        self.tree.vars[var[0].strip()] = var[2].strip()

    def parseFunction(self, lines):
        """
        Return the make file with the commands to execute the step
        given by the function name
        """
        logger.debug("Parsing function.")

        func = lines[0].strip().partition("(")
        params = func[2].strip(")")
        logger.debug("Function: " + func[0] + "(" + params + ")")

        function = Function()
        function.name = func[0]
        #Parse parameters
        if len(params) != 0:
            for param in params.split(","):
                logger.debug("Parsing parameter: " + param)
                if param.find("=") > 0:
                    #This is a variable
                    param_split = param.partition("=")
                    logger.debug("Variable: " + param_split[0] + " = " + param_split[2])
                    function.param[param_split[0].strip()] = param_split[2].strip()
                else:
                    #This is a Makefile
                    logger.debug("Makefile: " + param)
                    function.file = param.strip()

        self.tree.functions[func[0]] = function
        del lines[0]

    def parseSection(self, lines):
        logger.debug("Parsing section.")

        section = lines[0].strip().partition(":")
        logger.debug("Section name: " + section[0])

        del lines[0]
        #Check if this parser instance has the root Node
        if self.tree.root == None:
            parser = Parser(self.tree)
        else:
            parser = Parser(self.tree.root)

        if section[0] not in self.tree.sections:
            self.tree.sections[section[0]] = list()

        self.tree.sections[section[0]].append(parser.parse(lines))

    def parseTarget(self, lines):
        logger.debug("Parsing target.")

        target = lines[0].strip()
        logger.debug("Target: " + target)
        self.tree.targets.append(target)
        del lines[0]

    def parse(self, lines):
        logger.debug("Parsing " + str(len(lines)) + " lines.")

        end = False
        while (len(lines) > 0) and (end != True):
            line = lines[0].strip()
            if line.find("#") == 0:
                logger.debug("Skipping comment.")
                logger.debug(line)
                del lines[0]
            elif line == "":
                del lines[0]
            else:
                if line.find(":") == 0:
                    del lines[0]
                    logger.debug("Ending section: " + line[1:len(line)])
                    end = True
                elif line.find("(") > -1:
                    self.parseFunction(lines)
                elif line.find("=") > -1:
                    self.parseVariable(lines)
                elif line.find(":") > -1:
                    self.parseSection(lines)
                else:
                    self.parseTarget(lines)

        self.tree.vars["root"] = os.getcwd()

        return(self.tree)
