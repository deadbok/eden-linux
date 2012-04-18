# -*- coding: utf-8 -*-
'''
@since: 14 Jan 2012
@author: oblivion
'''
import urwid
import log
import popupdialog


class EditPopUp(urwid.PopUpLauncher):
    '''
    Class with urwid pop up logic.
    '''
    signals = ['change']

    def __init__(self, original_widget, entry):
        '''
        Constructor
        '''
        log.logger.debug('Creating edit pop up with base: '
                         + str(original_widget))
        urwid.PopUpLauncher.__init__(self, original_widget)
        self.entry = entry
        self.edit = None
        self.value = ''
#        self.__super.__init__(original_widget)

    def close_pop_up(self):
        '''
        Called when the pop up should close.
        '''
        log.logger.debug("Closing pop up")
        urwid.PopUpLauncher.close_pop_up(self)

    def pop_up_set(self):
        '''
        Called when the selection has been made in the pop up.
        '''
        log.logger.debug("Getting value from pop up: " + self.edit.get_edit_text())
        self.value = self.edit.get_edit_text()
        #Announce that the value has changed
        self._emit("change")
        #Close the pop up
        urwid.PopUpLauncher.close_pop_up(self)

    def create_pop_up(self):
        '''
        Called to create the pop up.
        '''
        log.logger.debug('Creating pop up')
        #body
        #EditBox
        self.edit = urwid.Edit()
        self.edit.set_edit_text(self.entry.value)
        body = urwid.AttrMap(urwid.Filler(self.edit), 'option')
        #pop up
        pop_up = popupdialog.PopUpDialog(body)
        urwid.connect_signal(pop_up, 'close',
                             lambda button: self.close_pop_up())
        urwid.connect_signal(pop_up, 'set',
                             lambda button: self.pop_up_set())
        log.logger.debug('Pop up created')
        return pop_up

    def get_pop_up_parameters(self):
        '''
        This method is called each time this widget is rendered.
        '''
        log.logger.debug('Giving pop up parameters')
        return {'left': 0, 'top': 1, 'overlay_width': 30, 'overlay_height': 10}
