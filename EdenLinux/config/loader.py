'''
@since: 4 Jan 2012
@author: oblivion
'''
import log
import configtree
import configoption
import yaml
import filenode


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
        for doc in yaml_docs:
            node = configoption.ConfigOption()
            node.name = doc.name.upper()
            node.desc = doc.desc
            node.namespace = doc.namespace
            node.short_desc = doc.short_desc
            node.value = doc.value
            node.values = doc.values
            self.config_tree.add(node)


