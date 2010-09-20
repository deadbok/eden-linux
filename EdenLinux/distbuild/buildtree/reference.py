"""
Created on Sep 15, 2010

@author: oblivion
"""
from buildtree.base import Base
class Reference(Base):
    """
    A variable reference in the .conf file
    """
    def __init__(self, parent = None, name = "", nodes = OrderedDict()):
        """
        Constructor
        """
        Base.__init__(self, parent, name, nodes)

