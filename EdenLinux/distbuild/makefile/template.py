'''
Created on Sep 4, 2010

@author: oblivion
'''
from logger import logger
from makefile import Makefile
from makefile import MakefileError
import target

class Template(Makefile):
    """
    Class to handle Makefile templates
    """
    def __init__(self, filename = ""):
        """Constructor"""
        logger.debug("Entering Template.__init__")
        Makefile.__init__(self, filename)
#        self.read()

    def parseVar(self, line, pos):
        i = pos
        ret = ""
        done = False
        while not done:
            i += 1
            if i == len(line):
                done = True
            else:
                if line[i].isalnum() or line[i] == "-" or line[i] == "_" or line[i] == ".":
                    ret += line[i]
                else:
                    done = True

        return(ret, i)

    def expandVars(self, line, _vars):
        """Replace variable names, with their values"""
        logger.debug("Expanding variables from globals...")
        i = line.find("${")
        var_name = ""
        ret = ""
        logger.debug("Input string: " + line)

        if i > -1:
            ret = line[0:i]
            var_name, i = self.parseVar(line, i + 1)
            i += 1
            logger.debug("Found variable: " + var_name.strip())
            if var_name.strip() in _vars:
                value = _vars[var_name.strip()].strip()
                logger.debug("Value: " + value)
                ret += self.expandVars(value, _vars)
            else:
                logger.debug("Not in given dictionary")
                ret += "${" + var_name.strip() + "}"

            ret += self.expandVars(line[i:len(line)], _vars)
        else:
            logger.debug("No variables")
            ret = line

        logger.debug("Expanded string: " + ret)
        return(ret)

    def combine(self, _vars, var_postfix = "", lines = None):
        if not lines == None:
            self.parse(lines)
        elif not self.filename == "":
            self.read(self.filename)
        else:
            raise MakefileError("No file or data to combine")

        for entry in self.entries:
            if isinstance(entry, target.Target):
                _target = self.toMakeLine(self.expandVars(entry.target, _vars),
                                         var_postfix)
                prerequisites = self.toMakeLine(self.expandVars(entry.prerequisites, _vars), var_postfix)
                recipe = list()
                for line in entry.recipe:
                    recipe.append(self.toMakeLine(self.expandVars(line, _vars),
                                                  var_postfix))
                return(_target, prerequisites, recipe)

