"""Color management classes and functions"""
import curses
from logger import logger

def black():
    """Get the curses value of black."""
    return curses.COLOR_BLACK

def blue():
    """Get the curses value of blue."""
    return curses.COLOR_BLUE

def cyan():
    """Get the curses value of cyan."""
    return curses.COLOR_CYAN

def green():
    """Get the curses value of green."""
    return curses.COLOR_GREEN

def magenta():
    """Get the curses value of magenta."""        
    return curses.COLOR_MAGENTA

def red():
    """Get the curses value of red."""
    return curses.COLOR_RED

def white():
    """Get the curses value of white."""
    return curses.COLOR_WHITE
  
def yellow():
    """Get the curses value of yellow."""
    return curses.COLOR_YELLOW

DialogColors = dict()     
       
def next_color():
    return (len(DialogColors) + 1)

def add(bkgd, fgd):
    nr = next_color()
    logger.info("Add new color as: " + str(nr))
    DialogColors[nr] = curses.init_pair(nr, bkgd, fgd)
    return nr
    