
#!/usr/bin/python
'''
Created on 1 Sep 2011

@author: oblivion
'''
import os
import shutil
import log
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

def load_templates(root_dir):
    log.logger.info("Loading templates from: " + root_dir)
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
    log.init_file_log()
    log.init_console_log()
    log.logger.info("Make file Template engine V" + str(version))
    load_templates("tmpl")
    process_templates("mk", "build")


if __name__ == '__main__':
    main()
