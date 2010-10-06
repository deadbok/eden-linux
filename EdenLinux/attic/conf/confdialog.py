"""Curses window class.

    $Id: confdialog.py 186 2009-06-10 09:58:20Z oblivion $
"""
#I'm at my second python app, so i might be doing it C-style
from cursesui.logger import logger
from cursesui import window
from cursesui import textbox
from cursesui import color

class SelectDialog(window.Window):
    """Selection list dialog"""
    def __init__(self):
        window.Window.__init__()
        self.data = None

    def create(self, name):
        """Create a selection dialog from confdata"""
        pass
    
    def set_data(self, data):
        self.data = data

#TODO: Add color terminal checks
class ConfDialog:
    """This class manages the configuration dialog."""
    def __init__(self):
        self.root_window = window.RootWindow()
        self.main_window = None
        self.colors = color.DialogColors
        self.textbox = None
        
    def create(self):
        """Create the dialog"""
        try:            
            self.root_window.set_title("Root")
            
            self.main_window = window.add_window(self.root_window, "MainWindow",
                                            (1, 2), self.root_window.get_size())
            self.main_window.set_title("Global configuration options")
            
            self.textbox = textbox.add_textbox(self.main_window, "help",
                            "Spam and eggs. Spam, spam, spam, spam, and eggs",
                            (1, 2), (self.main_window.get_size()[0], 10))
            self.textbox.show_text()
            
            self.root_window.getch()
        except:
            self.root_window.close()
            logger.exception("Exception during ConfDialog creation")
            raise
            
            
    def close(self):
        """Destroy the dialog."""
        self.root_window.close()