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
        file = None
        #Save loop
        while done == False:
            #No open file
            filename = ""
            #Run through nodes
            for node in self.config_tree.iter():
                #Get a filename if it is empty
                if filename == "":
                    if node.filename not in filenames:
                        filename = node.filename
                        log.logger.debug("Saving entries to file: " + filename)

                #Save entry if it is owned
                if filename != "":
                    if node.filename == filename:
                        log.logger.debug("Saving entry: " + node.name)
            #If no file was found, we're done, else save the filename.
            if filename == "":
                done = True
            else:
                filenames.append(filename)
