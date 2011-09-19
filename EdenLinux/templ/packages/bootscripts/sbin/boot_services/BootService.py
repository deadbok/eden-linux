'''
Created on 6 Jan 2011

@author: oblivion
'''

class BootService(object):
    '''
    classdocs
    '''


    def __init__(self, name = ""):
        '''
        Constructor
        '''
        self.name = name
        self.next = None
        self.LSB_header = dict()

