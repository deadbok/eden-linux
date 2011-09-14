'''
Created on 5 Sep 2011

@author: oblivion
'''
import log

class Namespace(object):
    '''
    classdocs
    '''
    def __init__(self, name, env = None):
        '''
        Constructor
        '''
        self.name = name

        if env == None:
            self.env = dict()
        else:
            self.env = env

namespaces = dict()
namespaces["global"] = Namespace("global")
current = "global"

def add(namespace):
    namespaces[namespace.name] = namespace

def set_current(namespace):
    global current
    current = namespace


