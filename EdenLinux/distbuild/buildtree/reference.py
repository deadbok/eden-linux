"""
Created on Sep 15, 2010

@author: oblivion
"""
#import os
from base import Base
from comment import Comment
from logger import logger

class Reference(Base):
    """A variable reference in the .conf file"""
    def __init__(self, parent):
        """Constructor"""
        logger.debug("Constructing Reference object")
        Base.__init__(self, "ref")
        self.name += str(self.id())
        self.parent = parent
        self.local = True
        self.reference = ""
        self.varname = ""

    def __str__(self):
        """Return string representation"""
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
                #variable reference
                elif token == "{":
                    self.local = True
                    try:
                        while not token == "}":
                            token = tokens.pop()
                            if not token == "}":
                                self.reference += token
                    except IndexError:
                        raise SyntaxError("Missing } in reference; "
                                          + self.reference)
                    logger.debug("Local variable reference: "
                                 + self.reference)
                    done = True
                strip_spaces = False
                if self.reference.find(".") > -1:
                    self.local = False
        return(tokens, lines)

    def Link(self):
        logger.debug("Linking: " + str(self))
#        from function import Function
#        if self.reference.find(".") > -1:
#            target = self.parent.GetLocalVar(self.reference)
#        else:       
#            target = self.parent.GetGlobalVar(self.reference)
#            if target == None:
#                for node in self.Root().IterTree():
#                    if node.GetGlobalName() == self.reference:
#                        if isinstance(node.parent, Function):
#                            target = node.parent
#                        else:
#                            target = node
#            if not target == None:
#                self.Add(target, False)
#                self.varname = target.name
#            else:
#                logger.debug("Cannot find node: "
#                             + self.reference)
#                raise SyntaxError("Cannot find node "
#                                  + self.reference)

    def Get(self):
        """Get the referenced variable value"""
        if self.reference.find(".") > -1:
            self.local = False
        if self.local:
            return(self.GetLocalVar(self.reference).Get())
        else:
            return(self.GetGlobalVar(self.reference).Get())

    def GetRef(self):
        """Get the referenced object"""
        if self.reference.find(".") > -1:
            self.local = False
        if self.local:
            return(self.GetLocalVar(self.reference))
        else:
            return(self.GetGlobalVar(self.reference))


