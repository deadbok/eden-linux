"""
Created on Sep 14, 2010

@author: oblivion
"""
from string import printable
from string import ascii_letters
from string import digits
from ordereddict import OrderedDict
from logger import logger

def IsDistBuildConf(lines):
    """Check to see if this is a distbuild file"""
    if len(lines) > 0:
        if lines[0].strip() == "#distbuild":
            logger.debug("This is a distbuild configuration file")
            return(True)
    logger.debug("This is not a distuild configuration file")
    return(False)

class BaseSyntaxError(Exception):
    """Syntax error exception"""
    def __init__(self, msg = ""):
        """Constructor"""
        Exception.__init__()
        self.msg = msg

    def __str__(self):
        return(self.msg)

class Base(object):
    """Base class for the buildtree classes"""
    idnum = 0
    def __init__(self, name = ""):
        """Constructor"""
        if len(name.strip(printable)) > 0:
            logger.debug("Constructing Base object with an unspeakable name")
        else:
            logger.debug("Constructing Base object named: " + name)
        self.name = name
        self.parent = None
        self.nodes = OrderedDict()
        self.value = ""

    def __str__(self):
        """Return the name"""
        return(self.name)

    def id(self):
        """Create a unique ID"""
        ret = Base.idnum
        Base.idnum += 1
        return(ret)

    def Tokenize(self, line):
        """Split a line into tokens of either sequences of letters, numbers, -, 
        and _ or a separate token for any other character"""
        logger.debug("Tokenizing line: " + line.strip())
        token = ""
        tokens = list()
        #Run through all characters in the line
        for ch in line:
            #if this is an accepted character
            if ch in (ascii_letters + digits + "-" + "_"):
                #Add to token
                token += ch
            else:
                #Save the token, if one was found
                if len(token) > 0:
                    logger.debug("Adding token: " + token)
                    tokens.append(token)
                    token = ""
                #Add the character to the list of tokens
                #if not ch == " ":
                logger.debug("Adding token: " + ch)
                tokens.append(ch)
        if len(token) > 0:
            logger.debug("Adding token: " + token)
            tokens.append(token)
        logger.debug("Tokens in line: " + str(tokens))
        return(tokens)

    def Consume(self, tokens, lines):
        """Consume nothing"""
        return(tokens, lines)

    def Parse(self, lines):
        """Eat up lines, and fill in the tree"""
        logger.debug("Base consuming: " + str(len(lines)) + " lines")
        tokenized_lines = list()
        for line in lines:
            #Reverse the list so we can pop the start off the end ;)
            tokenized_line = self.Tokenize(line)
            tokenized_line.reverse()
            tokenized_lines.append(tokenized_line)
        tokenized_lines.reverse()
        self.Consume("", tokenized_lines)

    def Root(self, node = None):
        """Return the root of the tree"""
        if node == None:
            node = self
        #If the node has no parent, it is the root node
        if node.parent == None:
            return(node)
        else:
            #Try the parent of this node
            return(Base.Root(node.parent))

    def Add(self, node, adjust_root = True):
        """Add a new node"""
        if isinstance(node, Base):
            logger.debug("Adding node: " + node.name + " to: " + self.name)
            logger.debug("Node type: " + str(type(node)))
            logger.debug("Parent type: " + str(type(self)))
            if adjust_root:
                logger.debug("Setting parent to: " + str(self))
                node.parent = self
            self.nodes[node.name] = node
        else:
            logger.warning('Wrong type "' + str(type(node))
                           + '" of node, cannot add')
        return(node)

    def GetNode(self, name, root = None):
        """Get a node, belonging to root, or the current node"""
        if root == None:
            root = self
        if name in root.nodes:
            node = root.nodes[name]
            return(node)
        return(None)

    def GetLocalVar(self, name, raise_error_on_not_found = True):
        """Return a glocal variable by name"""
        if name in self.nodes:
            node = self.nodes[name]
            return(node)
        if self.parent == None:
            if raise_error_on_not_found:
                raise SyntaxError("Cannot find local variable: " + name)
            else:
                return(None)
        else:
            node = self.parent.GetLocalVar(name, raise_error_on_not_found)
            return(node)
        if raise_error_on_not_found:
            raise SyntaxError("Cannot find local variable: " + name)
        else:
            return(None)

    def GetGlobalVar(self, name):
        """Return a global variable by name"""
#        from variable import Variable
#        from reference import Reference
#        from function import Function
        node = self.Root()
        path = name.split(".")
        path.reverse()
        for node_name in path:
            node = node.GetNode(node_name)
        if node == None:
            raise SyntaxError("Cannot find variable: " + name)
        return(node)
#        for node in root.IterTree():
#            if isinstance(node, Variable):
#                if not isinstance(node.parent, Reference):
#                    if not isinstance(node.parent, Function):
#                        if name == node.GetGlobalName():
#                            return(node)
#        return(None)

    def GetPath(self):
        """Get the name of the nodes from the root of the tree to this node"""
        ret = list()
        node = self
        while node.parent != None:
            ret.append(node.name)
            node = node.parent
        return(ret)

    def GetPathToNode(self, target):
        """Get the name of the nodes from the given node of the tree to this
        node"""
        ret = list()
        node = self
        while node.name != target.name:
            ret.append(node.name)
            node = node.parent
            if node == None:
                ret.append(self.name)
                return(ret)
        return(ret)

    def Link(self):
        """Link references to their variables"""
        from data import Data
        from reference import Reference
        if not isinstance(self, (Reference, Data)):
            logger.debug("Linking in: " + self.name)
        for node in self.nodes.itervalues():
            node.Link()

    def IterNodes(self):
        """Iterate through first level of sub-nodes"""
        for node in self.nodes.itervalues():
            yield node

    def IterTree(self, root = None):
        """Iterate through all the nodes in the tree"""
        if root == None:
            root = self
        yield root
        last = root
        for node in root.IterTree():
            for child in node.IterNodes():
                yield child
                last = child
            if last == node:
                return

    def GetGlobalName(self, sep = "."):
        """Get the global name of the node"""
        node = self
        ret = ""
        if node.name.find(".") > -1:
            ret = node.name
        else:
            while not node.parent == None:
                ret += node.name
                node = node.parent
                if not node.parent == None:
                    ret += sep
        #logger.debug("Global name: " + ret)
        return(ret)
