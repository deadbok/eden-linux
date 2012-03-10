'''
@since on 6 Jan 2012
@author: oblivion
'''
import configoption
import log


class ConfigTree(configoption.ConfigOption):
    '''
    Config tree storing all options.
    '''
    def __init__(self):
        '''
        Constructor
        '''
        configoption.ConfigOption.__init__(self)
        self.name = 'global'

    def find(self, name, node=None):
        '''
        Find a node by name, return None if not found.
        '''
        #I'm the global one
        if name == 'global':
            return(self)
        #Start at the root if no other place is given
        if node == None:
            node = self
        #If the name is a path 
        if '.' in name:
            path = name.split('.')
            for part in path:
                node = self.find(part, node)
        else:
            #Find the node among the ones in this node
            for subnode in node.nodes:
                if subnode.name == name:
                    return(subnode)
        return(None)

    def add(self, node):
        '''
        Add a node to the tree
        @param node: The node to add
        @type node: configoption.ConfigOption
        '''
        if self.nodes == None:
            log.logger.debug('Creating root node list')
            self.nodes = list()
        #Global nodes belong to this root node
        if node.namespace == "global":
            log.logger.debug('Adding node: ' + node.name + ' to: global')
            node.parent = self
            self.nodes.append(node)
        else:
            path = node.namespace.split('.')
            log.logger.debug('Adding node: ' + node.name +
                             ' to: ' + node.namespace)
            current_node = self
            for current_path in path:
                next_node = self.find(current_path, current_node)
                if next_node != None:
                    current_node = next_node
                else:
                    #Create node if path does not exist
                    log.logger.debug('Adding node: ' + current_path)
                    next_node = configoption.ConfigOption(current_node)
                    next_node.name = current_path
                    next_node.nodes = list()
                    #Add node
                    current_node.nodes.append(next_node)
                    current_node = next_node
                    #Add node
                current_node.nodes.append(node)
            log.logger.debug('Adding node: ' + str(node))
