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
from StringIO import StringIO

version = 0.2

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
            namespaces["global"].env["namespace"] = namespace
            execfile(root_dir + "/" + entry, namespaces["global"].env)

def process_templates(root_dir, output_dir):
    '''Process templates in root dir and all subdirectories,
    and output them to a directory.
    '''
    for entry in os.listdir(root_dir):
        if not ((entry.find(".") == 0)):
            filename = root_dir + "/" + entry
            if os.path.isdir(filename):
                #Create target directory
                log.logger.info("Entering: " + filename)
                try:
                    os.makedirs(output_dir + "/" + entry, 0775)
                except OSError as exception:
                    if not exception.errno == 17:
                        raise exception
                    else:
                        log.logger.debug("Directory " + output_dir + "/"
                                         + entry + " already exists")
                #Process templates in the directory
                process_templates(filename, output_dir + "/" + entry)
            else:
                output_filename = output_dir + "/" + os.path.basename(filename)
                process_file(filename, output_filename)


def clean_output_dir(root_dir, output_dir, do_dirs = False):
    #Check for files that needs to be deleted
    for entry in os.listdir(output_dir):
        if not ((entry.find(".") == 0)):
            filename = output_dir + "/" + entry
            if os.path.isdir(filename):
                log.logger.info("Checking: " + filename)
                if do_dirs:
                    #Check if dir is in the template directory
                    if not os.path.exists(root_dir + "/" + entry):
                        log.logger.info("Removing directory: " + filename)
                        try:
                            shutil.rmtree(filename)
                        except OSError as exception:
                            raise exception
                    clean_output_dir(root_dir + "/" + entry, filename, True)
                else:
                    if os.path.isdir(root_dir + "/" + entry):
                        clean_output_dir(root_dir + "/" + entry, filename, True)
            else:
                #Check if file is in the template directory
                if not os.path.exists(root_dir + "/" + entry):
                    log.logger.info("Removing file: " + filename)
                    try:
                        os.remove(filename)
                    except OSError as exception:
                        raise exception


def update_template(tmpl_file, input_filename, output_filename):
    log.logger.info("Reading template: " + input_filename)
    lines = tmpl_file.readlines()
    template = inline.Inline(lines)
    #Dirty trick. I use StringIO to make sure the output lines are
    #formatted as the would be, hen read from a file
    temp_strio = StringIO()
    temp_strio.writelines(template.substitute(keywords.keywords))
    temp_strio.seek(0)
    output_lines = temp_strio.readlines()

    old_lines = None
    if os.path.exists(output_filename):
        with open(output_filename, "r") as old_file:
            old_lines = old_file.readlines()
            old_file.close()
    #Check if the new file is identical to the old
    if old_lines == None or old_lines != output_lines:
        log.logger.info("Writing file: " + output_filename)
        if len(output_lines) == 0:
            log.logger.warning('Output file "' + output_filename
                               + '" is empty')
        with open(output_filename, "w") as output_file:
            output_file.writelines(output_lines)
            output_file.close()

def process_file(input_filename, output_filename):
    with open(input_filename) as tmpl_file:
        line = tmpl_file.readline()
        if istemplate([line]):
            update_template(tmpl_file, input_filename, output_filename)
        else:
            #Check if the target file is up to date
            if os.path.isfile(output_filename):
                instat = os.stat(input_filename)
                outstat = os.stat(output_filename)
                if instat.st_mtime > outstat.st_mtime:
                    log.logger.info("Copying: " + input_filename)
                    shutil.copy2(input_filename,
                                 os.path.dirname(output_filename))
                else:
                    log.logger.debug("No need to update: " + output_filename)
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
    clean_output_dir(template_path, output_dir)


if __name__ == '__main__':
    main()
