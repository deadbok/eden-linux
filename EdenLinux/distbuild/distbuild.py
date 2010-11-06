#!/usr/bin/env python
"""Distbuild main program"""
import optparse
import os.path
import logging
import sections
from logger import logger
from logger import set_file_loglevel
from logger import set_console_loglevel
import buildtree.base
import buildtree.section

TREE = buildtree.section.Section("global")

def parse_buildtree(path):
    """Parse .conf file structure"""
    try:
        for entry in os.listdir(path):
            if os.path.isfile(path + "/" + entry):
                if os.path.splitext(entry)[1] == ".conf":
                    logger.info("Parsing: " + path + "/" + entry)
                    with file(path + "/" + entry) as conf_file:
                        lines = conf_file.read().splitlines()
                    if buildtree.base.IsDistBuildConf(lines):
                        TREE.Parse(lines)
            elif os.path.isdir(path + "/" + entry):
                if entry.strip().find(".") != 0:
                    parse_buildtree(path + "/" + entry)
    except IOError as exception:
        logger.error('Exception: "' + exception.strerror + '" accessing file: '
                     + path + "/" + entry)
    except OSError as exception:
        logger.error('Exception: "' + exception.strerror + '" accessing file: '
                     + path)

def main():
    """Main function"""
    usage = "usage: %prog [options] config_path"
    arg_parser = optparse.OptionParser(usage = usage)
    arg_parser.add_option("-v", "--verbose",
                          action = "store_true", dest = "verbose",
                          default = False,
                          help = "Print detailed progress [default]")
    arg_parser.add_option("-l", "--log-level",
                          type = "int", default = 2,
                          help = "Set the logging level for the log files (0-5)"
                          )
    (options, args) = arg_parser.parse_args()
    if len(args) == 0:
        arg_parser.print_help()
        return
    if options.log_level == 0:
        set_file_loglevel(logging.NOTSET)
    elif options.log_level == 1:
        set_file_loglevel(logging.DEBUG)
    elif options.log_level == 2:
        set_file_loglevel(logging.INFO)
    elif options.log_level == 3:
        set_file_loglevel(logging.WARNING)
    elif options.log_level == 4:
        set_file_loglevel(logging.ERROR)
    elif options.log_level == 5:
        set_file_loglevel(logging.CRITICAL)
    else:
        set_file_loglevel(logging.INFO)
    if options.verbose:
        set_console_loglevel(logging.DEBUG)
    #Save the config path
    config_path = args[0]
    try:
        parse_buildtree(config_path)
        #Create a node with the current work directory
        node = TREE.Add(buildtree.variable.Variable("root"))
        node.Set(os.getcwd())
        logger.info("Solving dependencies...")
        sections_makefile = sections.sections(TREE)
        logger.info("Creating Makefiles...")
        sections_makefile.write()
    except SyntaxError as exception:
        logger.exception(str(exception) + " in: "
                         + str(exception.filename))
    except Exception as exception:
        logger.exception("Error creating Makefiles: " + str(exception))

if __name__ == "__main__":
    main()
