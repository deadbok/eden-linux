'''
Created on Aug 29, 2010

@author: oblivion
'''
class Builder(object):
    '''
    classdocs
    '''
    def __init__(self, tree, path):
        '''
        Constructor
        '''
        self.tree = tree
        self.path = path

    def globals(self):
        makefile = open(self.path + "/globals.mk", "w")
        #Write global variables from the configuration files
        for name, var in self.tree.vars.iteritems():
            makefile.write(name.upper() + " = " + str(var) + "\n")

        #Write globals for all sections
        for name, var in self.tree.sections.iteritems():
            makefile.write(name.upper() + "_BUILD_DIR = " + name + "_" + self.tree.getVar("arch") + "\n")
        makefile.close()

    def build(self):
        self.globals()
