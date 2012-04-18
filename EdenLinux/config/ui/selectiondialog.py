# -*- coding: utf-8 -*-
'''
@since 2 Jan 2012
@author: oblivion
'''
import urwid
import optionswidget
import log
import window


class SelectionDialog(window.Window):
    '''
    Configuration dialog with a list of options, buttons, and a frame.
    '''
    signals = ['save']
    def __init__(self, loader):
        '''
        Constructor
        '''
        log.logger.debug("Creating SelectionDialog instance")
        #Top key help
        select_help = '''Move with the arrow keys, select and toggle with \
Enter or Space. Change focus with the Tab key.'''
        #Divider line
        widget = urwid.AttrMap(urwid.Divider(u'─', 1, 1), 'frame')
        #Pile the text and divider together
        self.header = urwid.Pile([urwid.Padding(urwid.Text(select_help),
                                                'center'),
                                  widget])
        #Create a list of option for the current page
        self.options_widget = optionswidget.OptionWidgets(loader.config_tree)
        self.options_widget.generate_page(loader.config_tree)
        urwid.connect_signal(self.options_widget,
                             'change', self.page_change)
        #Add them to a listbox
        self.options = urwid.AttrMap(urwid.ListBox(self.options_widget),
                                     'option')
        #Widget for help on the current option
        widget, _ = self.options_widget.get_focus()
        option_help = ''
        self.option_help = urwid.AttrMap(urwid.Filler(urwid.Text(option_help)),
                                         'option')
        #Used to create a margin at the left and right side of the main widgets
        margin = urwid.Filler(urwid.Text(''))
        #Arrange the listbox, and the text in two columns
        self.option_view = urwid.Columns([('fixed', 1, margin),
                                          self.options, self.option_help,
                                          ('fixed', 1, margin)], 3)
        #Divider line
        widget = urwid.AttrMap(urwid.Divider(u'─', 1, 0), 'frame')
        #Buttons
        #Save
        save_button = urwid.Button('Save')
        self.save_button = urwid.AttrMap(save_button, 'body', 'focus')
        #Signal save
        urwid.connect_signal(save_button, 'click',
                             lambda button: self._emit("save"))
        #Back
        back_button = urwid.Button('Exit')
        self.back_button = urwid.AttrMap(back_button, 'body', 'focus')
        #Signals
        urwid.connect_signal(back_button, 'click', self.back_handler)
        #Create a list of the button widgets
        buttons = list()
        buttons.append(self.save_button)
        buttons.append(self.back_button)
        #Feed it to a GridFlow widget
        self.button_bar = urwid.GridFlow(buttons, 10, 3, 1, 'center')
        #Create a footer by piling the buttons with the divider
        self.footer = urwid.Pile([widget, self.button_bar])
        #Create the body frame
        self.body = urwid.Frame(self.option_view, self.header, self.footer)
        widget = urwid.AttrWrap(self.body, 'body')
        #Window
        window.Window.__init__(self, widget)
        self.loader = loader

    def page_back(self):
        '''
        Go back a page or exit at root.
        '''
        page = self.options_widget.page
        log.logger.debug("Going back from page: " + page.name)
        if page.name == 'global':
            log.logger.debug("Closing UI.")
            raise urwid.ExitMainLoop()
        else:
            page = self.options_widget.page.parent
            log.logger.debug("Going back to page: " + page.name)
            self.options_widget.generate_page(page)

    def page_change(self):
        '''
        Update stuff on page change.
        '''
        log.logger.debug('"page_change" signal')
        if self.options_widget.page == 'global':
            self.back_button.original_widget.set_label('Exit')
        else:
            self.back_button.original_widget.set_label('Back')

    def back_handler(self, button):
        '''
        Handle back/exit button.
        '''
        log.logger.debug('"Click" signal from: ' + button.get_label())
        self.page_back()

    def change_focus(self):
        '''
        Change the focus item in the dialog.
        '''
        #Focus on options
        if self.body.get_focus() == 'body':
            self.body.set_focus('footer')
            self.button_bar.set_focus(self.save_button)
            log.logger.debug('Change focus: save')
        #Focus on buttons
        elif self.body.get_focus() == 'footer':
            if self.button_bar.get_focus() == self.save_button:
                self.button_bar.set_focus(self.back_button)
                log.logger.debug('Change focus: back')
            else:
                self.body.set_focus('body')
                log.logger.debug('Change focus: body')

    def keypress(self, size, key):
        '''Handle tab key to change focus.'''
        self._w.keypress(size, key)
        if key == 'tab':
            log.logger.debug('Handle key: tab')
            self.change_focus()
            return(None)
        return(key)
