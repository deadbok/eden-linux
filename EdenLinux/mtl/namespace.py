'''
Namespace support.

@since: 5 Sep 2011
@author: oblivion
'''
import log

namespaces = dict()
'''A dictonary of all namespaces'''

class Namespace(object):
    '''
    Class to define a namespace.
    '''
    def __init__(self, name, env = None):
        '''
        Constructor.
        
        @type name: str
        @param name: The name of the namespace.
        @type env: dict
        @param env: Environment used when executing python code, in this namespace.    
        '''
        self.name = name

        if env == None:
            if name == "global":
                self.env = dict()
            else:
                self.env = namespaces["global"].env
        else:
            self.env = env
        log.logger.debug("Created namespace: " + name)

namespaces["global"] = Namespace("global")

current = "global"
'''Keeps track of the current namespace'''

def add(namespace):
    '''
    Add a new namespace.
    
    @type namespace: L{namespace.Namespace}
    @param namespace: The new Namespace object.
    '''
    namespaces[namespace.name] = namespace

def set_current(namespace):
    '''Set the current namespace.
    
    @type namespace: str
    @param namespace: Name of the namespace to use
    '''
    if namespace not in namespaces.keys():
        add(Namespace(namespace))
    global current
    current = namespace


