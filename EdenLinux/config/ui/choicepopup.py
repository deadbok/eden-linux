# -*- coding: utf-8 -*-
'''
@since: 14 Jan 2012
@author: oblivion
'''
import urwid
import log
import choicepopupdialog


class ChoicePopUp(urwid.PopUpLauncher):
    '''
    Class with urwid pop up logic.
    '''
    def __init__(self, original_widget, entry):
        '''
        Constructor
        '''
        log.logger.debug('Creating pop up with base: ' + str(original_widget))
        urwid.PopUpLauncher.__init__(self, original_widget)
        self.entry = entry
#        self.__super.__init__(original_widget)

    def close_pop_up(self):
        '''Called when the pop up should close.'''
        log.logger.debug("Closing pop up")
        urwid.PopUpLauncher.close_pop_up(self)

    def create_pop_up(self):
        '''Called to create the pop up.'''
        log.logger.debug('Creating pop up')
        #body
        #pop up
        pop_up = choicepopupdialog.ChoicePopUpDialog()
        urwid.connect_signal(pop_up, 'close',
                             lambda button: self.close_pop_up())
        log.logger.debug('Pop up created')
        return pop_up

    def get_pop_up_parameters(self):
        '''This method is called each time this widget is rendered.'''
        log.logger.debug('Giving pop up parameters')
        return {'left': 0, 'top': 1, 'overlay_width': 30, 'overlay_height': 15}
