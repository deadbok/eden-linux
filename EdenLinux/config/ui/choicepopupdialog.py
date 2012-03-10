# -*- coding: utf-8 -*-
'''
@since: 27 Jan 2012
@author: oblivion
'''
import urwid
import log
import window


class ChoicePopUpDialog(window.Window):
    '''
    General purpose pop up dialog.
    '''
    signals = ['close']

    def __init__(self, body=None):
        '''
        Constructor
        '''
        log.logger.debug('Creating pop up dialog')
        if body == None:
            body = urwid.Filler(urwid.Text(''))
        self.body = body
        #Buttons
        #Save
        save_button = urwid.Button('Save')
        self.save_button = urwid.AttrMap(save_button, 'body', 'focus')
        #Back
        back_button = urwid.Button('Exit')
        self.back_button = urwid.AttrMap(back_button, 'body', 'focus')
        urwid.connect_signal(back_button, 'click',
                             lambda button: self._emit("close"))
        buttons = list()
        buttons.append(self.save_button)
        buttons.append(self.back_button)
        #Feed it to a GridFlow widget
        widget = urwid.GridFlow(buttons, 10, 5, 1, 'center')
        #Create a footer by piling the buttons with the divide
        widget = urwid.Pile([urwid.AttrMap(urwid.Divider(u'─', 1, 0),
                                                'frame'), widget])
        #Frame with buttons as footer.
        widget = urwid.Frame(body, footer=widget, focus_part='body')

        log.logger.debug('Pop up created')
        #Window
        window.Window.__init__(self, widget)
