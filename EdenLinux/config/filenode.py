'''
Simple configuration option object for YAML.
@since: Apr 6, 2012
@author: oblivion
'''
from yaml import YAMLObject


class FileNode(YAMLObject):
    '''
    Class to hold a YAML configuration option.
    '''
    yaml_tag = u'!ConfigVar'
    def __init__(self, name="", value="", short_desc="", desc="",
                 values="", namespace=""):
        '''
        Constructor
        '''
        self.name = name
        self.values = values
        self.value = value
        self.namespace = namespace
        self.short_desc = short_desc
        self.desc = desc

    def __repr__(self):
        '''
        Yaml.
        '''
        return "%s(name=%r, value=%r, short_desc=%r, desc=%r, values=%r, namespace=%r)" % (self.__class__.__name__, self.name, self.value, self.short_desc, self.desc, self.values, self.namespace)
