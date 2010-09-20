"""
Created on Sep 14, 2010

@author: oblivion
"""
from base import Base
from comment import Comment
from logger import logger
from ordereddict import OrderedDict

class Variable(Base):
    """
    A variable in the .conf file
    """
    def __init__(self, name = ""):
        """
        Constructor
        """
        logger.debug("Constructing Variable object")
        Base.__init__(self, name)

    def __str__(self):
        return(self.name + " = " + str(self.value))

    def Consume(self, tokens, lines):
        """Consume all local variables in the current line"""
        #strip leading spaces
        strip_spaces = True
        while len(tokens):
            token = tokens.pop()
            while strip_spaces and token == " ":
                token = tokens.pop()
            #Check for comments
            if token == "#":
                    logger.debug("Found comment")
                    node = Comment("")
                    lines = node.Consume(tokens, lines)
                    self.Add(node)
            logger.debug("Consuming token: " + token)
            if not token == "$":
                self.value += token
            else:
                self.value += "$"
            strip_spaces = False
        return(lines)

