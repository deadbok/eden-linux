'''
config related stuff.

@since: 2 Jan 2012
@author: oblivion
'''


def configfile():
    return("##config")


class ConfigVar(object):
    '''
    Class to generate config option variables
    '''
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

    def __str__(self):
        '''Stringify the config variable'''
        ret = '##CONFIG: ' + self.name.upper() + '\n'
#        if isinstance(self.value, bool):
#            if self.value:
#                ret += '##True'
#            else:
#                ret += '##False'
#            ret += '\n'
#        else:
        ret += '##' + repr(self.value) + '\n'
        ret += '##' + repr(self.values) + '\n'
        ret += '##' + namespace.current + '\n'
        ret += '##' + self.short_desc + '\n'
        ret += '##' + self.desc + '\n'
        #Handle boolean as a defined/undefined variable
        if isinstance(self.value, bool):
            if self.value:
                ret += self.name.upper() + '= 1'
            else:
                ret += '#' + self.name.upper() + '= 1'
            ret += '\n'
        else:
            ret += self.name.upper() + ':=' + str(self.value)
        return(ret)
