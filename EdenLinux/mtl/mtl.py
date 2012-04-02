#!/usr/bin/env python

'''
@since: 1 Sep 2011
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
import ordereddict
from namespace import namespaces
from StringIO import StringIO

VERSION = 0.2
PLUGIN_DESTROY = list()

def istemplate(lines):
    '''
    Check for template identifier in the lines.
    
    @type lines: str
    @param lines: The lines to test.
    @rtype: Bool
    @return: Whether the lines belong to a template
    '''
    if lines[0].find("#mtl") == 0:
        return(True)
    else:
        return(False)

def load_plugins(root_dir):
    '''
    Load plugins.
    
    @type root_dir: str
    @param root_dir: The directory to lo#Remove the entryad the plugins from.
    '''
    log.logger.info("Loading plugins from: " + root_dir)
    plugins = os.listdir(root_dir)
    index = 0
    stop = False
    entry = ""
    errors = 0
    #Run through all the plugins in the directory
    while len(plugins) > 0:
        #If there are as many errors loading the plugins, as there are plugins
        #there is no chance of solving the missing dependencies. So we stop.
        if errors == len(plugins):
            stop = True
        #We have reached the end, start over.
        if index >= len(plugins):
            index = 0
            errors = 0
        #Get the current source file
        entry = plugins[index]
        #Check if it is a python source file
        if entry.endswith(".py"):
            try:
                namespaces["global"].env["namespace"] = namespace
                namespaces["global"].env["ordereddict"] = ordereddict
                #RUN the plugin code in the global namespace
                execfile(root_dir + "/" + entry, namespaces["global"].env)
                #Remove the entry
                del plugins[index]
                log.logger.info(entry + "...OK")
                #Catch any exception and try loading the plugin at a later time.
                #Simple way of trying to solve missing stuff that are not yet
                #loaded from other plugins
            except Exception as exception:
                #If stop is set, we have a real error
                if stop:
                    #Re-raise
                    raise exception
                index += 1
                errors += 1
                log.logger.info(entry + "..." + str(exception) + "...waiting")
        else:
            #Remove the entry if it is not a python source file
            del plugins[index]


def process_templates(root_dir, output_dir):
    '''
    Process templates in root dir and all subdirectories,
    and output the results to a directory.
    
    @type root_dir: str
    @param root_dir: Root directory to load the templates from.
    @type output_dir: str
    @param output_dir: Directory to put the processed templates in.
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


def clean_output_dir(root_dir, output_dir, do_dirs=False):
    '''
    Check for files that needs to be deleted.
    '''
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
    '''
    Update the target of a template, checking if contents have changed.
    
    @type tmpl_file: File Object
    @param tmpl_file: An open template file.
    @type input_filename: str.
    @param input_filename: Name of the template file.
    @type output_filename: str
    @param output_filename: Name of the output file.
    '''
    log.logger.info("Reading template: " + input_filename)
    lines = tmpl_file.readlines()
    template = inline.Inline(lines)
    #Dirty trick. I use StringIO to make sure the output lines are
    #formatted as the would be, when read from a file
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
    '''
    Do something to a file.
        - If the file is a template update it
        - If it is some other type of file, copy it if needed
    
    @type input_filename: str
    @param input_filename: The name of the input file to work on
    @type output_filename: str
    @param output_filename: The name of the output file or directory
    '''
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
                #There is no spoon!
                #Copy the file to have one.
                log.logger.info("Copying: " + input_filename)
                shutil.copy2(input_filename,
                                 os.path.dirname(output_filename))
                #shutil.copy2(input_filename, os.path.dirname(output_filename))
        tmpl_file.close()
#Remove the entry

def main():
    '''Main entry point.'''
    usage = "usage: %prog [options] template_path output_dir"
    arg_parser = optparse.OptionParser(usage=usage)
    arg_parser.add_option("-v", "--verbose",
                          action="store_true", dest="verbose",
                          default=False,
                          help="Print detailed progress [default]")
    arg_parser.add_option("-l", "--log-level",
                          type="int", default=2,
                          help="Set the logging level for the log files (0-5)"
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
    #Make the output directory available in the global namespace
    namespaces["global"].env["mtl_output_dir"] = output_dir
    #Make a list available to register functions for destroying a plugin
    namespaces["global"].env["mtl_plugin_destroy"] = PLUGIN_DESTROY
    log.logger.info("Make file Template engine V" + str(VERSION))
    load_plugins("plugins")
    log.logger.info("Processing templates in: " + template_path)
    process_templates(template_path, output_dir)
    clean_output_dir(template_path, output_dir)
    for plugin in PLUGIN_DESTROY:
        plugin()


if __name__ == '__main__':
    main()
