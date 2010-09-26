"""
Created on Sep 23, 2010

@author: oblivion
"""
from base import Base
from comment import Comment
from data import Data
from reference import Reference
from logger import logger
from ordereddict import OrderedDict

class Target(Base):
    """
    A target in the .conf file
    """
    def __init__(self, name = ""):
        """
        Construct
        """
        logger.debug("Constructing Target object")
        Base.__init__(self, name)

    def __str__(self):
        return(self.value)

    def Consume(self, tokens, lines):
        """Consume target"""
        #strip leading spaces
        strip_spaces = True
        while len(tokens):
            token = tokens.pop()
            while strip_spaces and token == " ":
                token = tokens.pop()
            #Check for comments
            if token == "#":
                logger.debug("Found comment")
                node = self.Add(Comment(""))
                (tokens, lines) = node.Consume(tokens, lines)

            strip_spaces = False
        logger.debug("Setting target: " + self.name)
        self.value = self.name
        return(tokens, lines)
