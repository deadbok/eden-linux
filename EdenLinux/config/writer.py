'''
@since: 16 Mar 2012
@author: oblivion
'''
import log
import os.path
import configoption
import configtree
import yaml


class Writer(object):
    '''
    Class for writing configuration options to the make files.
    '''
    def __init__(self, config_dir):
        '''
        Constructor.

        @param config_dir: The directory to save .config.yaml to
        @type confige_dir: str
        '''
        log.logger.debug("Creating Writer for: " + config_dir)
        self.dir = config_dir
        self.config_tree = None

    def save_tree(self, config_tree):
        '''
        Save configuration options to files.
        
        @param config_tree: L{ConfigTree} to save
        @type config_tree: L{ConfigTree}  
        '''
        filename = self.dir + "/.config.yaml"
        log.logger.info("Saving tree in: " + filename)
        self.config_tree = config_tree

        config_file = open(filename, "w")
        node_list = list()
        for node in self.config_tree.iter():
            if node.name.isupper():
                node_list.append(node)
        yaml.dump_all(node_list, config_file)
#        #Keep track of files
#        filenames = ['']
#        done = False
#        #Save loop
#        while done == False:
#            #No open file
#            filename = ""
#            config_file = None
#            #Run through nodes
#            for node in self.config_tree.iter():
#                #Get a filename if it is empty
#                if filename == "":
#                    if node.filename not in filenames:
#                        filename = node.filename
#                        config_file = open(filename, "rw")
#                        log.logger.debug("Saving entries to file: " + filename)
#                #Save entry if it is owned
#                if filename != "":
#                    if node.filename == filename:
#                        log.logger.debug("Saving entry: " + node.name)
#                        self.save_node(node, config_file)
#            #If no file was found, we're done, else save the filename.
#            if filename == "":
#                done = True
#            else:
#                filenames.append(filename)
#
#    def save_node(self, node, config_file):
#        '''
#        Save a node to a file.
#        
#        @param node: Node to save
#        @type node: L{ConfigOption}
#        @param config_file: File to save the node to
#        @type config_file: file
#        '''
#        node_str = list()
#        node_str.append("##CONFIG: " + node.name)
#        log.logger.debug("Looking for: " + node_str[0])
#        line = config_file.readline()
#        while not line.startswith(node_str[0]):
#            line = config_file.readline()
#        #Go until the end of the block
#        while line.startswith("##"):
#            line = lin
