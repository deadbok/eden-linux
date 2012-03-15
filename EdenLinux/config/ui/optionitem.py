'''
@since: 13 Jan 2012
@author: oblivion
'''
import urwid
import log
import custombutton
import choicepopup


class OptionItem(urwid.WidgetWrap):
    '''
    General widget to handle changeable config options.
    '''
    def __init__(self, entry):
        '''
        Constructor
        '''
        log.logger.debug("Creating an OptionItem")
        #Handle boolean types
        if isinstance(entry.value, bool):
            log.logger.debug("Creating boolean selection: " + entry.name)
            widget = urwid.CheckBox(entry.short_desc, entry.value)
            urwid.connect_signal(widget, 'change', self.update_bool)
            widget = urwid.AttrMap(widget, 'option', 'focus')
        #Handle array types
        elif isinstance(entry.values, list):
            log.logger.debug('Creating a list selection.')
            self.button = custombutton.CustomButton(('[' + entry.value + '] ')
                                          + entry.short_desc)
            self.pop_up = choicepopup.ChoicePopUp(self.button, entry)
            urwid.connect_signal(self.button, 'click', self.show_list)
            urwid.connect_signal(self.pop_up, 'change', self.update_list)
            widget = urwid.AttrMap(self.pop_up, 'option', 'focus')

        urwid.WidgetWrap.__init__(self, widget)
        self.entry = entry

    def update_bool(self, changed, *args):
        '''
        Handle updating entries, when changed in the UI.
        '''
        self.entry.value = changed

    def show_list(self, button, *args):
        '''
        Show a selection dialog, to select a value.
        '''
        log.logger.debug('Updating list for: ' + button.label)
        self.pop_up.open_pop_up()
        #self._wrapped_widget.original_widget.open_pop_up()

    def update_list(self, item, *args):
        '''
        Update selected value.
        '''
        self.entry.value = self.pop_up.value
        self.button.set_label(('[' + self.entry.value + '] ')
                        + self.entry.short_desc)
