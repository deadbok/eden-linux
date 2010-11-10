'''
Created on Sep 3, 2010

@author: oblivion
'''
from logger import logger

class Conditional(object):
    """Makefile conditional"""
    def __init__(self, lines = None):
        logger.debug("Entering Conditional.__init__")
        if lines == None:
            self.lines = list()
        else:
            self.lines = lines

