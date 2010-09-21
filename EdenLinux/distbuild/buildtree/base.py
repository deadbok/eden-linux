"""
Created on Sep 14, 2010

@author: oblivion
"""
import string
from ordereddict import OrderedDict
from logger import logger

def IsDistBuildConf(lines):
    if lines[0].strip() == "#distbuild":
        logger.debug("This is a distbuild configuration file")
        return(True)

    logger.debug("This is not a distuild configuration file")
    return(False)

class Base(object):
    """
    Base class for the buildtree classes
    """
    def __init__(self, name = ""):
        """
        Constructor
        """
        if len(name.strip(string.printable)) > 0:
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

    def Tokenize(self, line):
        """Split a line into tokens of either sequences of letters, numbers, -, and _
        or a separate token for any other character"""
        logger.debug("Tokenizing line: " + line.strip())
        token = ""
        tokens = list()
        #Run through all characters in the line
        for ch in line.strip():
            #if this is an accepted character
            if ch in (string.ascii_letters + string.digits + "-" + "_"):
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

    def Parse(self, lines):
        """Eat up lines, and fill in the tree"""
        import section
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

    def Add(self, node):
        from data import Data
        from reference import Reference
        if isinstance(node, Base):
            if isinstance(node, Data):
                logger.debug("Adding data node to: " + self.name)
            elif isinstance(node, Reference):
                logger.debug("Adding reference node to: " + self.name)
            elif isinstance(self, Reference):
                logger.debug("Adding node: " + node.name + " to: (unspeakable name)")
            else:
                logger.debug("Adding node: " + node.name + " to: " + self.name)
            logger.debug("Node type: " + str(type(node)))
            logger.debug("Parent type: " + str(type(self)))
            logger.debug("Setting parent to: " + str(self))
            node.parent = self
            self.nodes[node.name] = node
        else:
            logger.warning('Wrong type "' + str(type(node)) + '" of node, cannot add')
        return(node)

    def GetNode(self, name, root = None):
        if root == None:
            root = self
        if name in root.nodes:
            node = root.nodes[name]
            return(node)
        return(None)

    def GetLocalVar(self, name):
        if name in self.nodes:
            node = self.nodes[name]
            return(node)
        if self.parent == None:
            return(None)
        else:
            node = self.parent.GetLocalVar(name)
            return(node)
        return(None)

    def GetGlobalVar(self, name):
        if name in self.Root().nodes:
            node = self.Root().nodes[name]
            return(node)
        return(None)

    def Link(self):
        from data import Data
        from reference import Reference
        if not isinstance(self, (Reference, Data)):
            logger.debug("Linking in: " + self.name)
        for node in self.nodes.itervalues():
            node.Link()

