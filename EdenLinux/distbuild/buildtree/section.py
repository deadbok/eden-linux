"""
Created on Sep 14, 2010

@author: oblivion
"""
from logger import logger
from ordereddict import OrderedDict
from base import Base
from function import Function
from variable import Variable
from comment import Comment
from reference import Reference
from data import Data
from target import Target

class Section(Base):
    """
    A section in the .conf file
    """
    def __init__(self, name = ""):
        """
        Constructor
        """
        logger.debug("Constructing Section object")
        Base.__init__(self, name)

    def __str__(self):
        return(self.name + ":")

    def Consume(self, tokens, lines):
        """Eat up lines in a section, and fill in the tree"""
        logger.debug("Section consuming: " + str(len(lines)) + " lines")
        while len(lines):
            tokens = lines.pop()
            logger.debug("Tokens: " + str(tokens))
            name = ""
            while len(tokens) > 0:
                token = tokens.pop()
                while token == " ":
                    token = tokens.pop()
                logger.debug("Consuming token: " + token)
                node = None
                if len(token) > 1:
                    #Save string, if the token is longer than one character
                    name = token.strip()
                    logger.debug("Name: " + name)
                else:
                    #If this is a section
                    if token == ":":
                        if name == "":
                            name = tokens.pop().strip()
                            logger.debug("Ending section: " + name)
                            return(tokens, lines)
                        else:
                            logger.debug("Found section: " + name)
                            node = self.GetNode(name)
                            if node == None:
                                logger.debug("Section does not exists")
                                node = self.Add(Section(name))
                            else:
                                if type(node) is Section:
                                    logger.debug("Section exists")
                                else:
                                    logger.warning("Overwriting node:")
                                    logger.warning("Node type: " + str(type(node)) + ". Value: " + node.value)
                                    node = self.Add(Section(name))

                    #if this is a variable declaration
                    elif token == "=":
                        logger.debug("Found variable: " + name)
                        node = self.Add(Variable(name))
                    elif token == "(":
                        logger.debug("Found function: " + name)
                        node = self.Add(Function(name))
                    elif token == "#":
                        logger.debug("Found comment")
                        node = self.Add(Comment())
                    elif token == "$":
                        logger.debug("Found reference")
                        node = self.Add(Reference())
                    #Check if we've found someone to parse the line 
                    if not node == None:
                        #Call the right parser
                        (tokens, lines) = node.Consume(tokens, lines)
                        name = ""
            #Anything else is a target
            if len(name) > 0:
                logger.debug("Found target")
                node = self.Add(Target(name))
                (tokens, lines) = node.Consume(tokens, lines)

    def HasSection(self, name):
        """Check if section has subsection name"""
        for node in self.IterNodes():
            if isinstance(node, Section):
                if node.name == name:
                    return(True)
        return(False)

    def GetSection(self, name):
        """Get a named section node"""
        for node in self.IterNodes():
            if isinstance(node, Section):
                if node.name == name:
                    return(node)
        return(None)
