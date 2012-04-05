'''
@since: 4 Jan 2012
@author: oblivion
'''
import log
import configtree
import yaml


class Loader(object):
    '''
    Class for loading configuration options from a YAML file.
    '''
    def __init__(self, yaml_filename):
        '''
        Constructor.

        @param yaml_filename: The YAML file to load the configuration from
        @type yaml_filename: str
        '''
        log.logger.info("Loading configuration from " + yaml_filename)
        self.config_tree = configtree.ConfigTree()
        yaml_docs = yaml.load_all(open(yaml_filename, "r"))
        for node in yaml_docs:
            node.name = node.name.upper()
            self.config_tree.add(node)


