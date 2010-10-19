'''
Created on Sep 3, 2010

@author: oblivion
'''
import os.path
from logger import logger
import variable
import target
import include

class MakefileSyntaxError(SyntaxError):
    def __init__(self, msg = ""):
        SyntaxError()
        self.msg = msg

    def __str__(self):
        return(self.msg)

class MakefileError(StandardError):
    def __init__(self, msg = ""):
        SyntaxError()
        self.msg = msg

    def __str__(self):
        return(self.msg)

class Makefile(object):
    """
    Class representing a Makefile
    """
    def __init__(self, filename = ""):
        """
        Constructor
        """
        logger.debug("Entering Makefile.__init__")
        self.lines = list()
        self.includes = list()
        self.vars = list()
        self.targets = list()
        self.filename = filename

    def addInclude(self, filename, ignore_missing = False):
        """Add an include statement to the Makefile"""
        logger.debug("Adding include file: " + filename)
        inc = include.Include(filename)
        inc.ignore_missing = ignore_missing
        self.includes.append(inc)

    def addVar(self, name, value):
        """Add a variable to the Makefile"""
        logger.debug("Adding variable: " + name + " = " + value)
        self.vars.append(variable.Variable(name, value))

    def addTarget(self, mktarget, prerequisites = "", recipe = list(), target_var_name = ""):
        """Add a target rule to the Makefile"""
        logger.debug("Adding target: " + mktarget + ": " + prerequisites)
        for line in recipe:
            logger.debug("    " + line)
        if target_var_name == "":
            self.targets.append(target.Target(mktarget, prerequisites, recipe))
        else:
            logger.debug("Using target variable: " + target_var_name)
            self.addVar(target_var_name, mktarget)
            self.targets.append(target.Target("$(" + target_var_name + ")", prerequisites, recipe))

    def addPhonyTarget(self, mktarget, prerequisites = "", recipe = list()):
        """Add a phony target rule to the Makefile"""
        logger.debug("Adding phony target: " + mktarget + ": " + prerequisites)
        for line in recipe:
            logger.debug("    " + line)

        self.targets.append(target.Target(mktarget, prerequisites, recipe, True))

    def parseVar(self, line, pos):
        """Return the variable name and position in a line"""
        logger.debug("Parsing variable in '" + line + "' at position: " + str(pos))
        #Start position
        i = pos
        ret = ""
        done = False
        while not done:
            #Advance one character
            i += 1
            #If we've reached the end
            if i == len(line):
                done = True
            else:
                #Check if this is a character acceptable in a variable name
                if line[i].isalnum() or line[i] == "-" or line[i] == "_":
                    #Add to return
                    ret += line[i]
                else:
                    #We've reached the end of the variable
                    done = True

        return(ret, i)

    def toMakeLine(self, line, var_suffix = ""):
        """Convert variables to make syntax"""
        logger.debug("Converting to make syntax")
        pos = line.find("$")
        var_name = ""
        logger.debug("Input string: " + line)
        ret = ""

        if not pos == -1:
            i = pos
            ret = line[0:i]
            if not pos == line.find("${"):
                if line[pos + 1].isalpha():
                    var_name, i = self.parseVar(line, i)
                    logger.debug("Found variable: " + var_name.strip())
                    ret += "$("
                    ret += var_name.upper() + ")"
                    ret += self.toMakeLine(line[i:len(line)], var_suffix)
                else:
                    ret += "$"
                    ret += self.toMakeLine(line[i + 1:len(line)], var_suffix)

            else:
                ret += "$("
                i = line.find("}")
                if i > -1:
                    #If this is a regular Makefile variable copy it
                    if line[pos + 2:i + 1].isupper():
                        ret += line[pos + 2:i + 1]
                        ret += self.toMakeLine(line[i + 1:len(line)], var_suffix)
                    else:
                        #else add the local prefix
                        logger.debug("Found local variable: " + line[pos + 2:i])
                        if var_suffix == "":
                            ret += line[pos + 2:i].upper()
                        else:
                            ret += line[pos + 2:i].upper() + "_" + var_suffix.upper()
                        ret += ")"
                        ret += self.toMakeLine(line[i + 1:len(line)], var_suffix)
                else:
                    logger.warning("No '}' character found in line: "
                                   + line)
                    raise MakefileSyntaxError("No '}' character found in line: "
                                              + line)
        else:
            logger.debug("No variable found")
            ret = line

        logger.debug("Converted string: " + ret)
        return(ret)

    def parse(self, lines):
        i = 0
        while len(lines) > i:
            stripped_line = lines[i].strip()
            #Comment
            if len(stripped_line) > 0:
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
                            recipe_lines.append(lines[i].strip("\n"))
                            i += 1

                    self.addTarget(target_line[0], target_line[2], recipe_lines)
                else:
                    logger.warning("Cannot parse: " + lines[i])
                i += 1
            else:
                i += 1

    def read(self, filename):
        self.filename = filename
        logger.debug("Reading Makefile: " + self.filename)
        try:
            with file(self.filename, "r") as makefile:
                lines = makefile.readlines()
            self.parse(lines)
        except IOError as e:
            logger.error('Exception: "' + e.strerror + '" accessing file: ' + self.filename)
            raise



    def write(self):
        logger.debug("Writing Makefile: " + self.filename)

        for i in self.includes:
            prefix = ""
            if i.ignore_missing:
                prefix = "-"
            self.lines.append(prefix + "include " + i.filename + "\n")

        self.lines.append("\n")

        for v in self.vars:
            self.lines.append(v.name + " = " + v.value + "\n")

        self.lines.append("\n")

        for t in self.targets:
            if t.phony:
                self.lines.append(".PHONY: " + t.target + " " + t.prerequisites + "\n")
            self.lines.append(t.target + ":" + t.prerequisites + "\n")
            for line in t.recipe:
                self.lines.append(line + "\n")
            self.lines.append("\n")

        try:
            file_lines = None
            if os.path.exists(self.filename):
                with file(self.filename, "r") as makefile:
                    file_lines = makefile.readlines()

            if file_lines == None or file_lines != self.lines:
                makefile = open(self.filename, "w")
                makefile.writelines(self.lines)
                makefile.close()
            else:
                logger.debug(self.filename + " skipped, the file is up to date.")
                return(False)

        except IOError as e:
            logger.error('Exception: "' + e.strerror + '" accessing file: ' + self.filename)

        return(True)
