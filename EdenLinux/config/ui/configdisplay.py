'''
@since 1 Jan 2012
@author: oblivion
'''

import urwid
import selectiondialog
import log


class ConfigDisplay(urwid.AttrMap):
    '''
    Base configuration display
    '''
    palette = [
            ('header', 'light green', 'dark blue'),
            ('body', 'black', 'light gray'),
            ('bg', 'white', 'dark blue'),
            ('frame', 'white', 'light gray'),
            ('shadow', 'black', 'black'),
            ('focus', 'black', 'white'),
            ('option', 'black', 'dark cyan')
            ]
    signals = ['save']
    def __init__(self, loader):
        '''
        Constructor, to create the basic layout
        '''
        log.logger.debug("Creating ConfigDisplay instance")
        #Main dialog
        self.dialog = selectiondialog.SelectionDialog(loader)
        urwid.connect_signal(self.dialog, 'save',
                             lambda button: self._emit("save"))
        widget = urwid.Filler(self.dialog, ('fixed top', 1),
                                    ('fixed bottom', 1))
        self.body = urwid.AttrMap(widget, 'body')
        #Title
        self.header = urwid.AttrMap(urwid.Padding(urwid.Text('Config'),
                                                  'center'), 'header')
        urwid.AttrMap.__init__(self, urwid.Frame(self.body,
                                                 self.header), 'bg')
