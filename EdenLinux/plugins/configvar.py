'''
config related stuff.

@since: 2 Jan 2012
@author: oblivion
'''
from yaml import YAMLObject

def configfile():
    '''
    Create the tag to identify a file with config valus.
    '''
    return("##config")


class ConfigVar(YAMLObject):
    '''
    Class to generate config option variables
    '''
    yaml_tag = u'!ConfigVar'
    def __init__(self, name="", value="", short_desc="", desc="",
                 values=""):
        '''
        Constructor.

        @param name: The name of the variable to create
        @type name: str
        @param value: The value to assign the variable
        @type value: object
        @param short_desc: Short description of the config option
        @type short_desc: str
        @param desc: Full description of the config option
        @type desc: str
        @param values: A list of possible values if option is a selection list
        '''
        self.name = name
        self.value = value
        self.short_desc = short_desc
        self.desc = desc
        self.values = values

    def __repr__(self):
        '''
        Yaml.
        '''
        return "%s(name=%r, value=%r, short_desc=%r, desc=%r, val)" % (self.__class__.__name__, self.name, self.value, self.short_desc, self.desc, self.values)

    def __str__(self):
        '''Stringify the config varfrom yaml import YAMLObjectiable'''
        yaml_doc.append(self)
        ret = ''
        return(ret)
