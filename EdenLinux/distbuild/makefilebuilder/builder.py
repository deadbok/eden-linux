'''
Created on Aug 29, 2010

@author: oblivion
'''
import os
import os.path
from logger import logger

class Builder(object):
    '''
    classdocs
    '''
    def __init__(self, tree):
        '''
        Constructor
        '''
        logger.debug("Entering Builder.__init__")
        self.tree = tree
        self.globals = dict()

    def createDir(self, dir):
        """Create dir if it does not exist"""
        if not os.path.exists(dir):
            os.makedirs(dir)

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

    def globalVars(self):
        """Create a dictionary of all global vars"""
        logger.debug("Processing global variables in buildtree...")

        #Write globals from root
        for name, value in self.tree.vars.iteritems():
            self.globals[name] = value
            logger.debug("Variable: " + name + " = " + value)

        #Write globals for all sections
        for name, var in self.tree.sections.iteritems():
            self.globals[name + "_build_dir"] = self.tree.getVar("build_dir") + "/" + name + "_" + self.tree.getVar("arch")
            logger.debug("Variable: " + name + "_build_dir" + " = " + self.tree.getVar("build_dir") + "/" + name + "_" + self.tree.getVar("arch"))


    def globalMK(self):
        """Create a Makefile holding all global variables."""
        filename = self.expandVars(self.tree.getVar("build_dir"), self.globals) + "/globals.mk"
        logger.info('Creating: ' + filename)
        makefile = open(filename, "w")
        #Write global variables
        for name, var in self.globals.iteritems():
            line = name.upper() + " = " + str(self.toMakeLine(var)) + "\n"
            logger.debug("Writing line: " + line)
            makefile.write(line)

        logger.debug("Closing: " + filename)
        makefile.close()

    def downloadMK(self):
        """Create a Makefile with rules to download all needed files."""
        download_dir = self.expandVars(self.tree.getVar("download_dir"), self.globals)

        logger.info('Creating: ' + download_dir + "/download.mk")

        self.createDir(download_dir)
        #Create file
        makefile = open(download_dir + "/download.mk", "w")
        makefile.write("include " + self.tree.getVar("root") + "/" + self.tree.getVar("build_dir") + "/globals.mk\n")

        #Get all urls in the buildtree
        urls = set(self.tree.getAllVar("url").values())

        #Open the template Makefile
        template_filename = self.expandVars(self.tree.getVar("template_dir"), self.globals) + "/download.mk"
        logger.debug("Opening template: " + template_filename)
        template_file = open(template_filename)
        template = template_file.read()
        logger.debug(template)

        #Create a target for downloading all files
        all_targets = ""
        for target in urls:
            all_targets += " $(DOWNLOAD_DIR)/" + os.path.basename(target)
        logger.debug("Writing target: download all:" + all_targets)
        makefile.write("download-all:" + all_targets)
        makefile.write("\n")
        makefile.write("\n")

        #Create rules to download each file
        vars = dict()
        for url in urls:
            vars.update({"url": url, "target": ("$(DOWNLOAD_DIR)/" + os.path.basename(url))})

            rule = list()
            for line in template.splitlines():
                rule.append(self.toMakeLine(self.expandVars(line, vars) + "\n"))

            logger.debug("Writing rule: " + str(rule))
            makefile.writelines(rule)
            makefile.write("\n")
            makefile.write("\n")

        logger.debug("Closing: " + download_dir + "/download.mk")
        makefile.close()

    def makefile(self):
        """Create the global Makefile"""
        logger.info('Creating: "Makefile"')

        makefile = open("Makefile", "w")
        makefile.write("include " + self.expandVars(self.tree.getVar("build_dir"), self.globals) + "/*.mk")
        makefile.write("\n")
        makefile.write("include " + self.expandVars(self.tree.getVar("build_dir"), self.globals) + "/*/*.mk")
        makefile.write("\n")

    def build(self):
        """Build the Makefiles from the buildtree"""
        logger.info("Creating Makefiles...")
        makefile_path = self.tree.getVar("build_dir")
        self.createDir(makefile_path)

        #Get all global variables
        self.globalVars()
        self.globalMK()
        self.downloadMK()
        self.makefile()
