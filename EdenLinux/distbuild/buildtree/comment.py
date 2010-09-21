"""
Created on Sep 16, 2010

@author: oblivion
"""
import hashlib
from base import Base
from data import Data
from ordereddict import OrderedDict
from logger import logger

class Comment(Base):
    """
    A Comment in the .conf file
    """
    def __init__(self):
        """
        Constructor
        """
        logger.debug("Constructing Comment object")
        Base.__init__(self, "")

    def __str__(self):
        """Return the comment"""
        ret = "#"
        for node in self.nodes.itervalues():
            ret += str(node)
        return(ret)

    def Consume(self, tokens, lines):
        """Consume the rest of the line"""
        while len(tokens) > 0:
            token = tokens.pop()
            logger.debug("Consuming token: " + token)
            node = self.Add(Data())
            node.value = token
        self.name = hashlib.md5(self.value).hexdigest()
        logger.debug("Name: " + self.name)
        return(tokens, lines)
