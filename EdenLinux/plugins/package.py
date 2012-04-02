'''
Basic package related functions.

@since: 7 Sep 2011
@author: oblivion
'''
import os

class Package(object):
    '''Class to encapsulate a software package.'''
    def __init__(self, src_dir = ".", build_dir = "", VERSION = "0.0", url = "http://localhost", target = "."):
        '''
        Constructor.
        
        @type src_dir: str
        @param src_dir: The directory to unpack the source into.
        @type build_dir: str
        @param build_dir: The directory i which to build the package.
        @type VERSION: str
        @param VERSION: Package VERSION.
        @type url: str
        @param url: Where to download the package.
        @type target: str
        @param target: The final target expected, when every rule has run.
        '''
        self.src_dir = src_dir
        self.build_dir = build_dir
        self.version = VERSION
        self.url = url
        self.target = target
        self.filename = os.path.basename(url)
        self.rules = ordereddict.OrderedDict()

    def vars(self):
        '''Create the default package variables'''
        ret = var_name("VERSION") + " := " + self.version + "\n"
        ret += var_name("src_dir") + " := " + self.src_dir + "\n"
        ret += var_name("build_dir") + " := "
        if self.build_dir == "":
            ret += self.src_dir + "\n"
        else:
            ret += self.build_dir + "\n"
        ret += var_name("file") + " := " + self.filename + "\n"
        ret += var_name("url") + " := " + self.url + "\n"
        ret += '\n'
        return(ret)

    def __str__(self):
        ret = self.vars()

        if len(self.rules) > 0:
            for rule in self.rules.itervalues():
                ret += str(rule)

        return(ret)

