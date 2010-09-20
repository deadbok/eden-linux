#!/usr/bin/env python
import optparse
import os.path
import logging
from logger import logger
from logger import set_file_loglevel
from logger import set_console_loglevel
from makefilebuilder import builder
import buildtree.base
import buildtree.section

tree = buildtree.section.Section("global")

def print_tree(node, level = 0):
    logger.info(("*" * level) + " " + str(node))
    for sub_node in node.nodes.itervalues():
        print_tree(sub_node, level + 1)

def parse_buildtree(path):
    logger.info("Entering path: " + path)
    try:
        for entry in os.listdir(path):
            if os.path.isfile(path + "/" + entry):
                if os.path.splitext(entry)[1] == ".conf":
                    logger.info("Parsing: " + entry)
                    conf_file = open(path + "/" + entry)
                    lines = conf_file.read().splitlines()
                    if buildtree.base.IsDistBuildConf(lines):
                        tree.Parse(lines)
            elif os.path.isdir(path + "/" + entry):
                if entry.strip().find(".") != 0:
                    parse_buildtree(path + "/" + entry)
    except IOError as e:
        logger.error('Exception: "' + e.strerror + '" accessing file: ' + path + "/" + entry)
    except OSError as e:
        logger.error('Exception: "' + e.strerror + '" accessing file: ' + path)

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

    parse_buildtree(config_path)

    logger.info("Build tree:")
    print_tree(tree)

    makefile_builder = builder.Builder(tree)
    makefile_builder.build()

if __name__ == "__main__":
    main()
