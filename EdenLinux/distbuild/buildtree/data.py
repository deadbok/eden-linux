"""
Created on Sep 16, 2010

@author: oblivion
"""
import os
from base import Base
from logger import logger

class Data(Base):
    """
    Plain unprocessed data from the .conf file
    """
    def __init__(self):
        """
        Constructor
        """
        logger.debug("Constructing Data object")
        Base.__init__(self, "data" + os.urandom(6))

    def __str__(self):
        return(self.value)

    def Consume(self, tokens, lines):
        """Consume the rest of the tokens"""
        while len(tokens) > 0:
            token = tokens.pop()
            self.value += token
        logger.warning("Found data chunk: " + self.value)
        return(tokens, lines)
