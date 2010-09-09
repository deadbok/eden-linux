'''
Created on Sep 9, 2010

@author: oblivion
'''

class OrderedDict(dict):
    """
    An ordered dictionary
    """
    def __init__(self, source = dict()):
        """
        Constructor
        """
        dict.__init__(source)
        self._keys = list()

    def __delitem__(self, key):
        dict.__delitem__(self, key)
        self._keys.remove(key)

    def __setitem__(self, key, item):
        dict.__setitem__(self, key, item)
        if key not in self._keys: self._keys.append(key)

    def clear(self):
        dict.clear(self)
        self._keys = []

    def copy(self):
        ret = dict.copy(self)
        ret._keys = self._keys[:]
        return ret

    def items(self):
        return zip(self._keys, self.values())

    def keys(self):
        return self._keys

    def popitem(self):
        try:
            key = self._keys[-1]
        except IndexError:
            raise KeyError('dictionary is empty')

        val = self[key]
        del self[key]

        return (key, val)

    def setdefault(self, key, failobj = None):
        dict.setdefault(self, key, failobj)
        if key not in self._keys: self._keys.append(key)

    def update(self, source):
        dict.update(self, source)
        for key in dict.keys():
            if key not in self._keys: self._keys.append(key)

    def values(self):
        return map(self.get, self._keys)
