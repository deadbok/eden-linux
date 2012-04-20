'''
@since: 6 Jan 2012
@author: oblivion
'''
import urwid
import log
import custombutton
import optionitem


class OptionWidgets(urwid.SimpleListWalker):
    '''
    Class to create a list of widgets for the current level in the configtree
    '''
    signals = ['change', 'modified']
    def __init__(self, config_tree):
        '''
        Constructor
        '''
        self.page = None
        self.widgets = list()
        self.config_tree = config_tree
        urwid.SimpleListWalker.__init__(self, self.widgets)
        urwid.register_signal(OptionWidgets, self.signals)

    def generate_page(self, node):
        '''
        Generate widgets for a level in the menu.
        
        @param node: The node from which to generate the page.
        @type node: L{ConfigOption}  
        '''
#        node = self.config_tree.find(name)
        log.logger.debug("Generating page: " + node.name)
        #Remove old entries
        del self[0:len(self)]
        #Handle an empty page
        if node.nodes != None:
            for entry in node.nodes:
                #Skip the root node
                if entry.name == 'global':
                    log.logger.debug('Skipping global')
                    continue
                #If all lower case, this node has sub-nodes
                if entry.name.islower():
                    log.logger.debug('Adding page button: ' + entry.name)
                    widget = custombutton.CustomButton(entry.name, right='>')
                    urwid.connect_signal(widget, 'click', self.change_page, entry)
                    widget = urwid.AttrMap(widget, 'option', 'focus')
                else:
                    widget = optionitem.OptionItem(entry)
                self.append(widget)

        self.page = node
        urwid.emit_signal(self, 'change')

    def change_page(self, button, entry):
        '''
        Handle changing to another page.
        '''
        log.logger.debug('"Change" signal from: ' + button.get_label())
        log.logger.debug("Changing to page: " + entry.name)
        self.generate_page(entry)
