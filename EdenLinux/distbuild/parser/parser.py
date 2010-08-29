'''
Created on Aug 25, 2010

@author: oblivion
'''
from logger import logger
from buildtree.node import Node

class Parser(object):
    def __init__(self):
        logger.debug("Entering Parser.__init__")

        self.tree = Node()

    def parseVariable(self, lines):
        logger.debug("Parsing variable.")

        var = lines[0].strip().partition("=")
        logger.debug("Variable: " + var[0] + " = " + var[2])
        del lines[0]
        self.tree.var[var[0]] = var[2]
        return((var[0], var[2]))

    def parseFunction(self, lines):
        """
        Return the make file with the commands to execute the step
        given by the function name
        """
        logger.debug("Parsing function.")

        func = lines[0].strip().partition("(")
        param = func[2].strip(")")
        logger.debug("Function: " + func[0] + "(" + param + ")")

        self.tree.function[func[0]] = param

        del lines[0]

    def parseSection(self, lines):
        logger.debug("Parsing section.")

        section = lines[0].strip().partition(":")
        logger.debug("Section name: " + section[0])

        del lines[0]
        parser = Parser()
        self.tree.section[section[0]] = parser.parse(lines)

    def parseTarget(self, lines):
        logger.debug("Parsing target.")

        target = lines[0].strip()
        logger.debug("Target: " + target)
        self.tree.target.append(target)
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
                elif line.find("=") > -1:
                    self.parseVariable(lines)
                elif line.find(":") > -1:
                    self.parseSection(lines)
                elif line.find("(") > -1:
                    self.parseFunction(lines)
                else:
                    self.parseTarget(lines)

        return(self.tree)
