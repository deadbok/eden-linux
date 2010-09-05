'''
Created on Sep 3, 2010

@author: oblivion
'''
from logger import logger

class Include(object):
    """
    Makefile includes
    """


    def __init__(self, filename = ""):
        """
        Constructor
        """
        logger.debug("Entering Include.__init__")

        self.filename = filename

