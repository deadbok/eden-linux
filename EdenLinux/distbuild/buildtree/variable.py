"""
Created on Sep 14, 2010

@author: oblivion
"""
from base import Base
from comment import Comment
from data import Data
from reference import Reference
from logger import logger
from ordereddict import OrderedDict

class Variable(Base):
    """
    A variable in the .conf file
    """
    def __init__(self, name = ""):
        """
        Construct
        """
        logger.debug("Constructing Variable object")
        Base.__init__(self, name)

    def __str__(self):
        ret = self.name + " = "
        for node in self.nodes.itervalues():
            ret += str(node)
        return(ret)

    def Consume(self, tokens, lines):
        """Consume all local variables in the current line"""
        #strip leading spaces
        strip_spaces = True
        while len(tokens):
            token = tokens.pop()
            while strip_spaces and token == " " and len(tokens) > 0:
                token = tokens.pop()
            #Check for comments
            if token == "#":
                logger.debug("Found comment")
                node = self.Add(Comment(""))
                (tokens, lines) = node.Consume(tokens, lines)
            else:
                logger.debug("Consuming token: " + token)
                if not token == "$":
                    node = self.Add(Data())
                    node.value = token
                else:
                    node = self.Add(Reference(self))
                    (tokens, lines) = node.Consume(tokens, lines)
            strip_spaces = False
        return(tokens, lines)

    def Set(self, value):
        self.nodes = OrderedDict()
        node = self.Add(Data())
        node.value = value

    def GetDeref(self):
        ret = ""
        for node in self.nodes.itervalues():
            if not isinstance(node, Comment):
                if isinstance(node, Reference):
                    ret += node.Get()
                else:
                    ret += str(node)
        return(ret)

    def Get(self):
        ret = ""
        for node in self.nodes.itervalues():
            if not isinstance(node, Comment):
                ret += str(node)
        return(ret)

