'''
Class to hold a configuration option.

@since:  5 Jan 2012
@author: oblivion
'''


class ConfigOption(object):
    '''
    Class to hold a configuration option.
    '''
    def __init__(self, parent=None):
        '''
        Constructor
        '''
        self.filename = ""
        self.name = ""
        self.values = list()
        self.value = ""
        self.namespace = ""
        self.short_desc = ""
        self.desc = ""
        self.nodes = None
        self.parent = parent

    def __str__(self):
        '''
        Return a string representation
        '''
        ret = 'Name: ' + self.name + ', '
        ret += 'Values: ' + str(self.values) + ', '
        ret += 'Value: ' + str(self.value) + ', '
        ret += 'Namespace: ' + self.namespace + ', '
        ret += 'Short description: ' + self.short_desc + ', '
        ret += 'Description: ' + self.desc + ','
        return(ret)

    def iter(self):
        '''
        Iterator.
        '''
        for node in self.nodes:
            if node.nodes != None:
                #Take care of the sub nodes first
                for subnode in node.iter():
                    yield subnode
            yield node
