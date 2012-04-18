'''
@since: 13 Jan 2012
@author: oblivion
'''
import urwid
import log
import custombutton
import choicepopup
import editpopup

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
        #Handle strings
        elif isinstance(entry.value, str):
            log.logger.debug("Creating an edit selection: " + entry.name)
            self.button = custombutton.CustomButton(('[' + entry.value + '] ')
                                                    + entry.short_desc)
            self.pop_up = editpopup.EditPopUp(self.button, entry)
            urwid.connect_signal(self.button, 'click', self.show_edit)
            urwid.connect_signal(self.pop_up, 'change', self.update_str)
            widget = urwid.AttrMap(self.pop_up, 'option', 'focus')
        else:
            log.logger.debug("Unknown item type for item: " + entry.name)
            raise ValueError("Unknown item type for item: " + entry.name)

        urwid.WidgetWrap.__init__(self, widget)
        self.entry = entry

    def update_bool(self, changed, *args):
        '''
        Handle updating entries, when changed in the UI.
        '''
        #BUG: urwid updates this value after the handler is called, so we make
        #do with a toggle
        #self.entry.value = changed.get_state()
        self.entry.value = not self.entry.value

    def show_list(self, button, *args):
        '''
        Show a selection dialog, to select a value.
        '''
        log.logger.debug('Updating list for: ' + button.label)
        self.pop_up.open_pop_up()
        #self._wrapped_widget.original_widget.open_pop_up()

    def show_edit(self, button, *args):
        '''
        Show an edit dialog for the value.
        '''
        log.logger.debug("Editing string for: " + button.label)
        self.pop_up.open_pop_up()

    def update_list(self, item, *args):
        '''
        Update selected value.
        '''
        self.entry.value = self.pop_up.value
        self.button.set_label(('[' + self.entry.value + '] ')
                        + self.entry.short_desc)

    def update_str(self, item, *args):
        '''
        Update selected value.
        '''
        self.entry.value = str(self.pop_up.value)
        self.button.set_label(('[' + self.entry.value + '] ')
                        + self.entry.short_desc)
