'''
Created on Sep 3, 2010

@author: oblivion
'''
from logger import logger
from makefilebuilder import variable
from makefilebuilder import target
from makefilebuilder import include


class Makefile(object):
    """
    Class representing a Makefile
    """
    def __init__(self, filename):
        """
        Constructor
        """
        logger.debug("Entering Makefile.__init__")
        self.lines = list()
        self.includes = list()
        self.vars = list()
        self.targets = list()
        self.filename = filename

    def addInclude(self, filename):
        logger.debug("Adding include file: " + filename)
        self.includes.append(include.Include(filename))

    def addVar(self, name, value):
        logger.debug("Adding variable: " + name + " = " + value)
        self.vars.append(variable.Variable(name, value))

    def addTarget(self, mktarget, prerequisites = "", recipe = list()):
        logger.debug("Adding target: " + mktarget + ": " + prerequisites)
        for line in recipe:
            logger.debug("    " + line)

        self.targets.append(target.Target(mktarget, prerequisites, recipe))

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

    def toMakeLine(self, line):
        """Convert variables to make syntax"""
        logger.debug("Converting to make syntax")
        pos = line.find("$")
        var_name = ""
        logger.debug("Input string: " + line)
        ret = ""

        if not pos == -1:
            i = pos
            ret = line[0:i]
            if not pos == line.find("$("):
                var_name, i = self.parseVar(line, i)

                logger.debug("Found variable: " + var_name.strip())

                ret += "$(" + var_name.upper() + ")"
                ret += self.toMakeLine(line[i:len(line)])
            else:
                ret += "$"
                ret += self.toMakeLine(line[i + 1:len(line)])
        else:
            logger.debug("No variable found")
            ret = line

        logger.debug("Converted string: " + ret)
        return(ret)

    def read(self):
        logger.debug("Reading Makefile: " + self.filename)

        try:
            makefile = open(self.filename, "r")

            lines = makefile.readlines()

            i = 0
            while len(lines) > i:
                stripped_line = lines[i].strip()
                #Comment
                if stripped_line[0] == "#":
                    logger.debug("Skipping comment: " + lines[i])
                #Include
                elif stripped_line.find("include") == 0:
                    logger.debug("Processing include line: " + stripped_line)
                    self.addInclude(stripped_line.replace("include", ""))
                elif stripped_line.find("=") > -1:
                    logger.debug("Processing variable line: " + stripped_line)
                    var = stripped_line.partition("=")
                    self.addVar(var[0], var[2])
                elif stripped_line.find(":") > -1:
                    logger.debug("Processing target line: " + stripped_line)
                    target_line = stripped_line.partition(":")
                    recipe_lines = list()
                    i += 1
                    while len(lines) > i:
                        if not lines[i].strip() == "\n":
                            logger.debug("Processing recipe line: " + lines[i])
                            recipe_lines.append(lines[i])
                            i += 1

                    self.addTarget(target_line[0], target_line[2], recipe_lines)
                else:
                    logger.warning("Cannot parse: " + lines[i])

                i += 1
        except IOError:
            logger.error("IO exception accessing file: " + self.filename)


    def write(self):
        logger.debug("Writing Makefile: " + self.filename)

        for i in self.includes:
            self.lines.append("include " + i.filename + "\n")

        self.lines.append("\n")

        for v in self.vars:
            self.lines.append(v.name + " = " + v.value + "\n")

        self.lines.append("\n")

        for t in self.targets:
            self.lines.append(t.target + ": " + t.prerequisites + "\n")
            for line in t.recipe:
                self.lines.append(line + "\n")
            self.lines.append("\n")

        try:
            makefile = open(self.filename, "w")

            makefile.writelines(self.lines)

            makefile.close()
        except IOError:
            logger.error("IO exception accessing file: " + self.filename)
