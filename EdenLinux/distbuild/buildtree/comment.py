"""
Created on Sep 16, 2010

@author: oblivion
"""
import hashlib
from base import Base
from ordereddict import OrderedDict
from logger import logger

class Comment(Base):
    """
    A Comment in the .conf file
    """
    def __init__(self, name = ""):
        """
        Constructor
        """
        logger.debug("Constructing Comment object")
        Base.__init__(self, name)

    def __str__(self):
        """Return the value"""
        return("#" + self.value)

    def Consume(self, tokens, lines):
        """Consume the rest of the line"""
        while len(tokens) > 0:
            token = tokens.pop()
            logger.debug("Consuming token: " + token)
            self.value += token

        self.name = hashlib.md5(self.value).hexdigest()
        logger.debug("Name: " + self.name)
        return(lines)
