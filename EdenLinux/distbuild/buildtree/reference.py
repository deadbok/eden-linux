"""
Created on Sep 15, 2010

@author: oblivion
"""
import os
from base import Base
from comment import Comment
from logger import logger
from ordereddict import OrderedDict

class Reference(Base):
    """A variable reference in the .conf file"""
    def __init__(self, parent):
        """Constructor"""
        logger.debug("Constructing Reference object")
        Base.__init__(self, "ref" + os.urandom(6))
        self.parent = parent
        self.local = True
        self.reference = ""

    def __str__(self):
        ret = "$"
        if self.local:
            ret += "{"
        ret += self.reference
        if self.local:
            ret += "}"
        return(ret)

    def Consume(self, tokens, lines):
        """Consume reference"""

        #strip leading spaces
        strip_spaces = True
        done = False
        while not done:
            token = tokens.pop()
            if not (strip_spaces and token == " "):
                #Check for comments
                if token == "#":
                        logger.debug("Found comment")
                        node = self.Add(Comment(""))
                        (tokens, lines) = node.Consume(tokens, lines)
                        done = True
                #Local variable reference
                elif token == "{":
                    self.local = True
                    self.reference = tokens.pop()
                    #Pop the ")"
                    tokens.pop()
                    logger.debug("Local variable reference: " + self.reference)
                    done = True
                #Global variable reference
                else:
                    self.local = False
                    self.reference = token
                    logger.debug("Global variable reference: " + self.reference)
                    done = True
                strip_spaces = False
        return(tokens, lines)

    def Link(self):
        if self.reference.islower():
            from variable import Variable
            if self.local:
                node = self.parent.GetLocalVar(self.reference)
                if isinstance(node, Variable):
                    self.Add(node)
                else:
                    logger.warning("Cannot find local variable: " + self.reference)
            else:
                node = self.parent.GetGlobalVar(self.reference)
                if isinstance(node, Variable):
                    self.Add(node)
                else:
                    logger.warning("Cannot find global variable: " + self.reference)

    def Get(self):
        if self.reference in self.nodes:
            return(self.nodes[self.reference].Get())
        return(None)
