'''
Created on Aug 29, 2010

@author: oblivion
'''
from logger import logger

class Function(object):
    '''
    Represents a function to call a Makefile
    '''
    def __init__(self):
        '''
        Constructor
        '''
        self.name = ""
        self.file = ""
        self.param = dict()

    def __str__(self):
        """Return a string representation"""
        temp = self.name + "(" + self.file

        for name, value in self.param.iteritems():
            temp += ", " + name + " = " + value

        temp += ")"
        return(temp)

    def getParam(self, name):
        """Get a named parameter."""
        if name in self.param:
            return(self.param[name])
        else:
            logger.error('Parameter "' + name + '" not found in function "' + self.name + '"')
