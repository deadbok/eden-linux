#!/usr/bin/env python
import optparse
import os.path
from logger import logger
from configparser import parser
from makefilebuilder import builder

def print_tree(tree, level = 0):
    for key, var in tree.vars.iteritems():
        logger.info((" " * level) + "Variable: " + key + " = " + str(var))

    for key, var in tree.functions.iteritems():
        logger.info((" " * level) + "Function: " + str(var))

    for target in tree.targets:
        logger.info((" " * level) + "Target: " + target)

    for key, var in tree.sections.iteritems():
        logger.info((" " * level) + "Section: " + key)
        for section in var:
            print_tree(section, level + 1)

def parse_buildtree(path, conf_parser):
    logger.info("Entering path: " + path)

    for entry in os.listdir(path):
        if os.path.isfile(path + "/" + entry):
            if os.path.splitext(entry)[1] == ".conf":
                logger.info("Parsing: " + entry)
                conf_file = open(path + "/" + entry)
                lines = conf_file.read().splitlines()
                if conf_parser.IsDistBuildConf(lines):
                    conf_parser.parse(lines)

        if os.path.isdir(path + "/" + entry):
            if entry.strip().find(".") != 0:
                parse_buildtree(path + "/" + entry, conf_parser)


def main():
    """Main functions"""
    logger.debug("Entering main.")

    usage = "usage: %prog [options] config_path"
    arg_parser = optparse.OptionParser(usage = usage)
    arg_parser.add_option("-v", "--verbose",
                      action = "store_true", dest = "verbose", default = True,
                      help = "Print detailed progress [default]")

    (options, args) = arg_parser.parse_args()

    if len(args) == 0:
        arg_parser.print_help()
        return

    #Save the config path
    config_path = args[0]

    config_parser = parser.Parser()
    parse_buildtree(config_path, config_parser)

    logger.info("Build tree:")
    print_tree(config_parser.tree)

    makefile_builder = builder.Builder(config_parser.tree)
    makefile_builder.Build()

if __name__ == "__main__":
    main()
