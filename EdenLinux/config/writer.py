'''
@since: 16 Mar 2012
@author: oblivion
'''
import log
import os.path
import configoption
import configtree


class Writer(object):
    '''
    Class for writing configuration options to the make files.
    '''
    def __init__(self, makefiles_dir):
        '''
        Constructor.

        @param makefile_dir: The directory with the config makefiles
        @type makefile_dir: str
        '''
        log.logger.debug("Creating Writer for: " + makefiles_dir)
        self.dir = makefiles_dir
        self.config_tree = None

    def save_tree(self, config_tree):
        '''
        Save configuration options to files.
        
        @param config_tree: L{ConfigTree} to save
        @type config_tree: L{ConfigTree}  
        '''
        log.logger.info("Saving tree in: " + self.dir)
        self.config_tree = config_tree

        #Keep track of files
        filenames = ['']
        done = False
        #Save loop
        while done == False:
            #No open makefile
            filename = ""
            config_file = None
            #Run through nodes
            for node in self.config_tree.iter():
                #Get a filename if it is empty
                if filename == "":
                    if node.filename not in filenames:
                        filename = node.filename
                        config_file = open(filename, "rw")
                        log.logger.debug("Saving entries to makefile: " + filename)
                #Save entry if it is owned
                if filename != "":
                    if node.filename == filename:
                        log.logger.debug("Saving entry: " + node.name)
                        self.save_node(node, config_file)
            #If no makefile was found, we're done, else save the filename.
            if filename == "":
                done = True
            else:
                filenames.append(filename)

    def save_node(self, node, config_file):
        '''
        Save a node to a file.
        
        @param node: Node to save
        @type node: L{ConfigOption}
        @param config_file: File to save the node to
        @type config_file: file
        '''
        node_str = list()
        node_str.append("##CONFIG: " + node.name)
        node_str.append("##" + node.value)
        log.logger.debug("Looking for: " + node_str[0])
        lines = config_file.readlines()
        for line in lines:
            if line.strip() == node_str[0]:
                log.logger.info("Saving node.")
