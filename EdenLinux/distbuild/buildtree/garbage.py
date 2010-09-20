"""
Created on Sep 16, 2010

@author: oblivion
"""
from base import Base
from logger import logger
from ordereddict import OrderedDict

class Garbage(Base):
    """
    A garbage in the .conf file
    """
    def __init__(self, name = ""):
        """
        Constructor
        """
        logger.debug("Constructing Garbage object")
        name = "garbage"
        Base.__init__(self, name)

    def Consume(self, tokens, lines):
        """Consume the rest of the line"""
        while len(tokens) > 0:
            token = tokens.pop()
            self.value += token + ", "
        logger.warning("Found garbage chunk: " + self.value)
        return(lines)
