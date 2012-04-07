'''
@since: 16 Mar 2012
@author: oblivion
'''
import log
import yaml
import filenode


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
        doc_list = list()
        for node in self.config_tree.iter():
            if node.name.isupper():
                doc = filenode.FileNode()
                doc.name = node.name
                doc.desc = node.desc
                doc.namespace = node.namespace
                doc.short_desc = node.short_desc
                doc.value = node.value
                doc.values = node.values
                doc_list.append(doc)
        yaml.dump_all(doc_list, config_file)
        config_file.close()
