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
        self.inline = True

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
        return(ret)

    def Consume(self, tokens, lines):
        """Consume parameters"""
        name = ""
        node = None
        sub_tokens = list()
        while len(tokens) > 0:
            token = tokens.pop()
            if not token == ")":
                while (token != ",") and (len(tokens) > 0):
                    #transform  \, to ,
                    if token == "\\":
                        if len(tokens) > 0:
                            token = tokens.pop()
                            if token != ",":
                                sub_tokens.append("\\")
                    sub_tokens.append(token)
                    token = tokens.pop()
                sub_tokens.reverse()
                if len(sub_tokens) > 0:
                    #Makefile template
                    if "mk" in sub_tokens:
                        filename = ""
                        node = self.Add(Variable("func_makefile"))
                        while len(sub_tokens) > 0:
                            token = sub_tokens.pop()
                            if not token == " ":
                                filename += token
                        node.Set(filename)
                        self.Add(node)
                    #Variable
                    elif "=" in sub_tokens:
                        token = sub_tokens.pop()
                        #Skip spaces
                        while token == " ":
                            token = sub_tokens.pop()
                        #Get variable name
                        name = token
                        token = sub_tokens.pop()
                        #Pop the equal sign
                        while not token == "=":
                            token = sub_tokens.pop()
                        logger.debug("Found variable: " + name)
                        node = self.Add(Variable(name))
                        (sub_tokens, lines) = node.Consume(sub_tokens, lines)
                    #Check for comments
                    elif sub_tokens[0] == "#":
                        logger.debug("Found comment")
                        node = self.Add(Comment(""))
                        (sub_tokens, lines) = node.Consume(sub_tokens[1:len(sub_tokens)], lines)
                    #Target or dependencies
                    else:
                        dependencies = ""
                        target = ""
                        #If a target exists, this is a dependency
                        if "func_target" in self.nodes:
                            #Create variable if it isn't there
                            if not "func_dependencies" in self.nodes:
                                node = self.Add(Variable("func_dependencies"))
                            #Add tokens
                            while len(sub_tokens) > 0:
                                token = sub_tokens.pop()
                                dependencies += token
                            node.Set(dependencies)
                        else:
                            #Create variable
                            node = self.Add(Variable("func_target"))
                            #Add tokens                            
                            target += " "
                            while len(sub_tokens) > 0:
                                token = sub_tokens.pop()
                                target += token #.lstrip()
                            node.Set(target)
        #Consume code, if it is an inline function
        if len(lines) > 0:
            tokens = lines.pop()
            if len(tokens) > 0:
                if tokens[0] == "{":
                    logger.debug("Reading inline code")
    #                tokens = lines.pop()
    #                while not (tokens[0] == "}") and (len(lines) > 0):
    #                    tokens = lines.pop()
                else:
                    lines.append(tokens)
        return(tokens, lines)
