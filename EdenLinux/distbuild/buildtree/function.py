"""
Created on Aug 29, 2010

@author: oblivion
"""
from base import Base
from variable import Variable
from comment import Comment
from logger import logger
from ordereddict import OrderedDict

class Function(Base):
    """
    A variable in the .conf file
    """
    def __init__(self, name = ""):
        """
        Constructor
        """
        logger.debug("Constructing Function object")
        Base.__init__(self, name)

    def __str__(self):
        ret = self.name + "("
        items = len(self.nodes)
        if len(self.nodes) > 0:
            for node in self.nodes.itervalues():
                ret += str(node)
                if items > 1:
                    ret += ", "
                    items -= 1
            ret += ")"
        else:
            ret += ")"
        return(ret)

    def Consume(self, tokens, lines):
        """Consume parameters"""
        name = ""
        node = None
        sub_tokens = list()
        while len(tokens) > 0:
            token = tokens.pop()
            if not token == ")":
                while (not (token == ",")) and (len(tokens) > 0):
                    sub_tokens.append(token)
                    token = tokens.pop()
                sub_tokens.reverse()
                if len(sub_tokens) > 0:
                    #Makefile template
                    if "mk" in sub_tokens:
                        node = Variable("makefile")
                        while len(sub_tokens) > 0:
                            token = sub_tokens.pop()
                            if not token == " ":
                                node.value += token
                        self.Add(node)
                    #Variable
                    elif "=" in sub_tokens:
                        name = sub_tokens.pop()
                        logger.debug("Found variable: " + name)
                        node = Variable(name)
                        lines = node.Consume(sub_tokens, lines)
                        self.Add(node)
                    #Check for comments
                    elif sub_tokens[0] == "#":
                        logger.debug("Found comment")
                        node = Comment("")
                        lines = node.Consume(sub_tokens[1:len(sub_tokens)], lines)
                        self.Add(node)
                    #Target or dependencies
                    else:
                        #If a target exists, this is a dependency
                        if "target" in self.nodes:
                            #Create variable if it isn't there
                            if not "dependencies" in self.nodes:
                                node = Variable("dependencies")
                                self.Add(node)
                            #Add tokens
                            self.nodes["dependencies"].value += " "
                            while len(sub_tokens) > 0:
                                token = sub_tokens.pop()
                                self.nodes["dependencies"].value += token.lstrip()
                        else:
                            #Create variable
                            node = Variable("target")
                            self.Add(node)
                            #Add tokens                            
                            self.nodes["target"].value += " "
                            while len(sub_tokens) > 0:
                                token = sub_tokens.pop()
                                self.nodes["target"].value += token.lstrip()
        return(lines)
