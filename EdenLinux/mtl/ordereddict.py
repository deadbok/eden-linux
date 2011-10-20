'''
Dictonary with ordered elements.

@since Sep 9, 2010
@author: oblivion
'''
from itertools import izip
from itertools import imap

class OrderedDict(dict):
    """Ordered dict implementation.
    
    B{see:} U{http://aspn.activestate.com/ASPN/Cookbook/Python/Recipe/107747}
    """
    def __init__(self, data = None):
        '''
        Constructor.

        @type data: dict
        @param data: A dictionary used for initialisation. 
        '''
        dict.__init__(self, data or {})
        self._keys = dict.keys(self)

    def __delitem__(self, key):
        '''
        Delete given item.
        
        @type key: hashable
        @param key: The key of the item to delete.
        '''
        dict.__delitem__(self, key)
        self._keys.remove(key)

    def __setitem__(self, key, item):
        '''
        Set the item at key to the new item, or add it.
        
        @type key: hashable
        @param key: The key of the item to set/add
        @type item: object
        @param item: The item to set/add
        '''
        dict.__setitem__(self, key, item)
        if key not in self._keys:
            self._keys.append(key)

    def __iter__(self):
        '''
        Return the list of keys in the dictionary.
        
        @rtype: list
        @return: A list of key in the dictionary
        '''
        return iter(self._keys)

    def clear(self):
        '''Remove all items from the dictionary.'''
        dict.clear(self)
        self._keys = []

    def copy(self):
        '''Return a shallow copy of the dictionary.'''
        d = OrderedDict()
        d.update(self)
        return d

    def items(self):
        '''
        Return a list of C{(key, value)} pairs.
        
        @rtype: list
        @return: A list of C{(key, value)} pairs
        '''
        return zip(self._keys, self.values())

    def iteritems(self):
        '''
        Return an iterator over the dictionary's C{(key, value)} pairs.
        
        @rtype: iterator
        @return: an iterator over the dictionary's C{(key, value)} pairs.
        '''
        return izip(self._keys, self.itervalues())

    def keys(self):
        '''
        Return a list the dictionary's keys.
        
        @rtype: list
        @return: a list the dictionary's list of keys.
        '''
        return self._keys[:]

    def pop(self, key, default = object()):
        '''
        If key is in the dictionary, remove it and return its value,
        else return default. If default is not given and key is not in 
        the dictionary, a KeyError is raised.
        
        @type key: hashable
        @param key: The key for the item to pop
        @type default: object
        @param default: An object to return, of key is not in the dictionary
        @rtype: object
        @return: The value of item at key, or default
        '''
        if default is object():
            #If the key is in the list, remove it. The call to dict.pop should
            #succeed, since the key should be there.
            if key in self._keys:
                self._keys.remove(key)
            return dict.pop(self, key)
        elif key not in self:
            return default
        self._keys.remove(key)
        return dict.pop(self, key, default)

    def popitem(self):
        '''
        Remove and return and arbitrary C{(key, value)} pair.
        
        @rtype: tuple
        @return: C{(key, value)} pair of the deleted item
        '''
        (key, value) = dict.popitem()
        self._keys.remove(key)
        return (key, value)

    def setdefault(self, key, failobj = None):
        dict.setdefault(self, key, failobj)
        if key not in self._keys:
            self._keys.append(key)

    def update(self, dict):
        for (key, val) in dict.items():
            self[key] = val

    def values(self):
        return map(self.get, self._keys)

    def itervalues(self):
        return imap(self.get, self._keys)
