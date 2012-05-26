'''
Created on 26 May 2012

@author: oblivion
'''
class ConfigVarItem(ConfigVar):
    '''
    classdocs
    '''
    def __init__(self, name="", value="", short_desc="", desc=""):
        ConfigVar.__init__(self, name, valtype="Item", value, short_desc, desc,
                 values="")
