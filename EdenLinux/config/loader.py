'''
@since: 4 Jan 2012
@author: oblivion
'''
import log
import os.path
import configoption
import configtree


class Loader(object):
    '''
    Class for loading configuration options from the make files.
    '''
    def __init__(self, makefiles_dir):
        '''
        Constructor.

        @param makefile_dir: The directory with the config makefiles
        @type makefile_dir: str
        '''
        log.logger.info("Loading files from " + makefiles_dir)
        self.config_tree = configtree.ConfigTree()
        self.load_dir(makefiles_dir)
        self.dir = makefiles_dir

    def load_file(self, filename):
        '''
        Load configuration options from a file

        @param filename: The name of the file to load the options from
        @type filename: str
        '''
        log.logger.debug("Reading file: " + filename)
        with open(filename) as config_file:
            lines = config_file.readlines()

            #Skip empty files
            if len(lines) == 0:
                log.logger.debug("File is empty")
                return

            #Skip files without header
            if lines[0].strip() != '##config':
                log.logger.debug("File has no config info")
                return

            log.logger.info("Loading file: " + filename)

            i = 0
            while(len(lines) > i):
                line = lines[i]
                if line.startswith("##CONFIG: "):
                    var_name = line.replace("##CONFIG: ", "").strip()
                    log.logger.debug("Found option: " + var_name)
                    config_option = configoption.ConfigOption()
                    config_option.name = var_name
                    #next line: value
                    i += 1
                    value = lines[i].strip("##\n")
                    config_option.value = eval(value)
                    #next line: values
                    i += 1
                    values = lines[i].strip("##\n")
                    if values == "''":
                        config_option.values = list()
                    else:
                        config_option.values = eval(values)
                    #next line: name space
                    i += 1
                    config_option.namespace = lines[i].strip("##\n")
                    #next line: short description
                    i += 1
                    config_option.short_desc = lines[i].strip("##\n")
                    #next line: Full description
                    i += 1
                    config_option.desc = lines[i].strip("##\n")
                    log.logger.debug("Config option: " + str(config_option))
                    #Save filename for later use
                    config_option.filename = filename
                    #Add to tree
                    self.config_tree.add(config_option)
                i += 1

    def load_dir(self, directory):
        '''
        Load all config options from files in the directory and descend into
        all sub-directories.

        @param directory: The directory to start loading files from
        @type directory: str
        '''
        log.logger.debug("Entering: " + directory)
        for root, dirs, files in os.walk(directory):
            log.logger.debug("Root: " + root)
            #Exclude the build directory
            #TODO: Do not hard code the path
            if 'build' in dirs:
                dirs[:] = [d for d in dirs if d != 'build']
            #Try loading *.mk files
            for filename in files:
                if os.path.splitext(filename)[1] == '.mk':
                    self.load_file(os.path.join(root, filename))
