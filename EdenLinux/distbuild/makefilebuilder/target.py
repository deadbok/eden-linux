'''
Created on Sep 3, 2010

@author: oblivion
'''
from logger import logger

class Target(object):
    """Makefile target"""
    def __init__(self, target = "", prerequisites = "", recipe = list()):
        logger.debug("Entering Target.__init__")

        self.target = target
        self.prerequisites = prerequisites
        self.recipe = recipe
