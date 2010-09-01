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

    def expand_vars(self, line, vars):
        """Replace variable names, with their values"""
        logger.debug("Expanding variables from globals...")
        i = line.find("$")
        var_name = ""
        logger.debug("Input string: " + line)

        if i > -1:
            ret = line[0:i]
            done = False
            while not done:
                i += 1
                if i == len(line):
                    done = True
                else:
                    if line[i].isalnum() or line[i] == "-" or line[i] == "_":
                        var_name += line[i]
                    else:
                        done = True

            logger.debug("Found variable: " + var_name.strip())
            if var_name.strip() in vars:
                value = vars[var_name.strip()]
                logger.debug("Value: " + value)
                ret += value
            else:
                logger.debug("Not in given dictionary")
                ret += "$" + var_name.strip()

            ret += self.expand_vars(line[i:len(line)], vars)
        else:
            logger.debug("No variables")
            ret = line

        logger.debug("Expanded string: " + ret)
        return(ret)

    def expand_vars_global(self, line):
        """Replace variable names, with their values"""
        logger.debug("Expanding variables from globals...")
        i = line.find("$")
        var_name = ""
        logger.debug("Input string: " + line)

        if i > -1:
            ret = line[0:i]
            done = False
            while not done:
                i += 1
                if i == len(line):
                    done = True
                else:
                    if line[i].isalnum() or line[i] == "-" or line[i] == "_":
                        var_name += line[i]
                    else:
                        done = True

            logger.debug("Found variable: " + var_name.strip())
            if self.tree.hasVar(var_name.strip()):
                value = self.expand_vars_global(self.tree.getVar(var_name.strip())).strip()
                logger.debug("Global: " + value)
                ret += value
            else:
                logger.debug("Not global")
                ret += "$" + var_name.strip()

            ret += self.expand_vars_global(line[i:len(line)])
        else:
            logger.debug("No variables")
            ret = line

        logger.debug("Expanded string: " + ret)
        return(ret)

    def globals(self):
        """Create a Makefile holding all global variables."""
        logger.info('Creating: ' + self.expand_vars_global(self.tree.getVar("build_dir")) + "/globals.mk")
        makefile = open(self.expand_vars_global(self.tree.getVar("build_dir")) + "/globals.mk", "w")
        #Write global variables from the configuration files
        for name, var in self.tree.vars.iteritems():
            line = name.upper() + " = " + str(self.expand_vars_global(var))\
                    + "\n"
            logger.debug("Writing line: " + line)
            makefile.write(line)

        #Write globals for all sections
        for name, var in self.tree.sections.iteritems():
            line = name.upper() + "_BUILD_DIR = " + self.tree.getVar("build_dir") + "/" + name + "_" + self.tree.getVar("arch") + "\n"
            logger.debug("Writing line: " + line)
            makefile.write(line)

        logger.debug("Closing: " + self.expand_vars_global(self.tree.getVar("build_dir")) + "/globals.mk")
        makefile.close()

    def downloads(self):
        """Create a Makefile with rules to download all needed files."""
        download_dir = self.expand_vars_global(self.tree.getVar("download_dir"))

        logger.info('Creating: ' + download_dir + "/download.mk")

        #Create dir if it does not exist
        if not os.path.exists(download_dir):
            os.makedirs(download_dir)
        #Create file
        makefile = open(download_dir + "/download.mk", "w")

        #Get all urls in the buildtree
        urls = set(self.tree.getAllVar("url").values())

        #Open the template Makefile
        template_filename = self.expand_vars_global(self.tree.getVar("template_dir")) + "/download.mk"
        logger.debug("Opening template: " + template_filename)
        template_file = open(template_filename)
        template = template_file.read()
        logger.debug(template)

        #Expand global variables in template
        temp = list()
        for line in template.splitlines():
            temp.append(self.expand_vars_global(line))

        #Create a target for downloading all files
        all_targets = ""
        for target in urls:
            all_targets += " " + download_dir + "/" + os.path.basename(target)
        logger.debug("Writing target: download all:" + all_targets)
        makefile.write("download-all:" + all_targets)
        makefile.write("\n")
        makefile.write("\n")

        #Create rules to download each file
        for url in urls:
            vars = {"url": url, "target": (download_dir + "/" + os.path.basename(url))}

            rule = list()
            for line in temp:
                rule.append(self.expand_vars(line, vars) + "\n")

            logger.debug("Writing rule: " + str(rule))
            makefile.writelines(rule)
            makefile.write("\n")
            makefile.write("\n")

        logger.debug("Closing: " + download_dir + "/download.mk")
        makefile.close()


    def build(self):
        """Build the Makefiles from the buildtree"""
        logger.info("Creating Makefiles...")
        makefile_path = self.tree.getVar("build_dir")
        if not os.path.exists(makefile_path):
            os.makedirs(makefile_path)

        self.globals()
        self.downloads()
