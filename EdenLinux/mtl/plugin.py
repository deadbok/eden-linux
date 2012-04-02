'''
Plugin support.

@since: 2 Apr 2012
@author: oblivion
'''
import log

class Plugin(object):
    '''
    Class hold plugin info.
    '''
    def __init__(self, name, destructor=None):
        '''
        Constructor.
        
        @type name: str
        @param name: The name of the plugin.
        @type destructor: Callable
        @param destructor: The function to call when the plugin is destroyed.        
        '''
        self.name = name
        self.destroyed = False
        self.destructor = destructor
        log.logger.debug("Created plugin: " + name)

    def destroy(self):
        '''
        Hook to cleanup function.
        '''
        if self.destructor != None:
            self.destructor()
        log.logger.debug("Destroyed plugin: " + self.name)
        self.destroyed = True

