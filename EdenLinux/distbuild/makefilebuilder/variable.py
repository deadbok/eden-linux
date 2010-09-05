'''
Created on Sep 3, 2010

@author: oblivion
'''
from logger import logger

class Variable(object):
    """Makefile variable"""
    def __init__(self, name = "", value = 0):
        logger.debug("Entering Variable.__init__")

        self.name = name
        self.value = value
