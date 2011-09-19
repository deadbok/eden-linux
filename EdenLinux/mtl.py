#!/usr/bin/env python

'''
Created on 1 Sep 2011

@author: oblivion
'''
import optparse
import os
import shutil
import log
import logging
import inline
import keywords
import namespace
from namespace import namespaces

version = 0.1

def istemplate(lines):
    if lines[0].find("#mtl") == 0:
        return(True)
    else:
        return(False)

def load_plugins(root_dir):
    log.logger.info("Loading plugins from: " + root_dir)
    for entry in os.listdir(root_dir):
        if entry.find(".py") > -1:
            log.logger.info(entry)
            namespaces[namespace.current].env["namespace"] = namespace
            execfile(root_dir + "/" + entry, namespaces[namespace.current].env)

def process_templates(root_dir, output_dir):
    '''Process templates in root dir and all subdirectories,
    and output them to a directory.
    '''
    for entry in os.listdir(root_dir):
        if not ((entry.find(".") == 0)):
            filename = root_dir + "/" + entry
            if os.path.isdir(filename):
                log.logger.info("Entering: " + filename)
                try:
                    os.makedirs(output_dir + "/" + entry, 0775)
                except OSError as exception:
                    if not exception.errno == 17:
                        raise exception
                    else:
                        log.logger.debug("Directory " + output_dir + "/" + entry + " already exists")
                process_templates(filename, output_dir + "/" + entry)
            else:
                output_filename = output_dir + "/" + os.path.basename(filename)
                #Check if the target file is up to date
                if os.path.isfile(output_filename):
                    instat = os.stat(filename)
                    outstat = os.stat(output_filename)
                    if instat.st_mtime > outstat.st_mtime:
                        process_template(filename, output_filename)
                    else:
                        log.logger.debug("No need to update: " + output_filename)
                else:
                    process_template(filename, output_filename)

def process_template(input_filename, output_filename):
    with open(input_filename) as tmpl_file:
        line = tmpl_file.readline()
        if istemplate([line]):
            log.logger.info("Reading template: " + input_filename)
            lines = tmpl_file.readlines()
            template = inline.Inline(lines)
            log.logger.info("Writing file: " + output_filename)
            with open(output_filename, "w") as output_file:
                output_file.writelines(template.substitute(keywords.keywords))
                output_file.close()
        else:
            log.logger.info("Copying: " + input_filename)
            shutil.copy2(input_filename, os.path.dirname(output_filename))
        tmpl_file.close()

def main():
    usage = "usage: %prog [options] template_path output_dir"
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
        log.init_file_log(logging.NOTSET)
    elif options.log_level == 1:
        log.init_file_log(logging.DEBUG)
    elif options.log_level == 2:
        log.init_file_log(logging.INFO)
    elif options.log_level == 3:
        log.init_file_log(logging.WARNING)
    elif options.log_level == 4:
        log.init_file_log(logging.ERROR)
    elif options.log_level == 5:
        log.init_file_log(logging.CRITICAL)
    else:
        log.init_file_log(logging.INFO)
    if options.verbose:
        log.init_console_log(logging.DEBUG)
    else:
        log.init_console_log()
    #Save the config path
    template_path = args[0]
    output_dir = args[1]
    log.logger.info("Make file Template engine V" + str(version))
    load_plugins("plugins")
    process_templates(template_path, output_dir)


if __name__ == '__main__':
    main()
