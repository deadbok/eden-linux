"""A checkbox for cursesui"""
import curses
from logger import logger
import window
import color

class CheckBox(window.Window):
    """The checkbox class"""

    def __init__(self):
        """Constructor."""
        window.Window.__init__(self)
        
        self.text = ""
        
    def create(self, name):
        """Create a new textbox."""
        self.name = name
        self.curses_window.bkgd(" ",
                                curses.color_pair(color.DialogColors().window))