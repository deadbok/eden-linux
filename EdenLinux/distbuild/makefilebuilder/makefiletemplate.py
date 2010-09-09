'''
Created on Sep 4, 2010

@author: oblivion
'''
from logger import logger
from makefilebuilder.makefile import Makefile

class MakefileTemplate(Makefile):
    """
    Class to handle Makefile templates
    """
    def __init__(self, filename):
        """
        Constructor, read in template
        """
        logger.debug("Entering MakefileTemplate.__init__")
        Makefile.__init__(self, filename)
        self.read()


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
                ret += self.expandVars(value, vars)
            else:
                logger.debug("Not in given dictionary")
                ret += "$" + var_name.strip()

            ret += self.expandVars(line[i:len(line)], vars)
        else:
            logger.debug("No variables")
            ret = line

        logger.debug("Expanded string: " + ret)
        return(ret)

    def combine(self, vars, var_prefix = ""):
        target = self.toMakeLine(self.expandVars(self.targets[0].target, vars), var_prefix)
        prerequisites = self.toMakeLine(self.expandVars(self.targets[0].prerequisites, vars), var_prefix)
        recipe = list()
        for line in self.targets[0].recipe:
            recipe.append(self.toMakeLine(self.expandVars(line, vars)))

        return(target, prerequisites, recipe)
