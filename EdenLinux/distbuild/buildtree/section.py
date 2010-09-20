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
from garbage import Garbage

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
                #if this is not a variable declaration
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
                            return(lines)
                        else:
                            logger.debug("Found section: " + name)
                            node = self.GetNode(name)
                            if node == None:
                                logger.debug("Section does not exists")
                                node = Section(name)
                            else:
                                if type(node) is Section:
                                    logger.debug("Section exists")
                                else:
                                    logger.warning("Overwriting node:")
                                    logger.warning("Node type: " + str(type(node)) + ". Value: " + node.value)
                                    node = Section(name)

                    #if this is a variable declaration
                    elif token == "=":
                        logger.debug("Found variable: " + name)
                        node = Variable(name)
                    elif token == "(":
                        logger.debug("Found function: " + name)
                        node = Function(name)
                    elif token == "#":
                        logger.debug("Found comment")
                        node = Comment("")
                    #Check if we've found someone to parse the line 
                    if not node == None:
                        #Call the right parser
                        lines = node.Consume(tokens, lines)

                    else:
                        #Pass anything unknown along
                        node = Garbage(self)
                        tokens.append(name)
                        name = ""
                        lines = node.Consume(tokens, lines)
                    self.Add(node)
