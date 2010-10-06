"""Window objects of the cursesui"""

from cursesui.logger import logger
import curses
import color

class WindowError(Exception):
    """Exception class for windows objects."""
    def __init__(self, value):
        Exception.__init__()
        self.value = value

    def __str__(self):
        return repr(self.value)

class Window:
    """ A general windows object."""
    def __init__(self):
        """Construct an default windows."""
        self.pos = list([0, 0])
        self.size = list([0, 0])
        
        self.curses_window = None
        
        self.name = ""
        self.windows = list()
        self.title = ""
        self.border = 3
                    
    def create(self, name):
        """Create a new window."""
        try:
            self.name = name
            self.curses_window.bkgd(" ",
                            curses.color_pair(color.WINDOW))
            self.curses_window.box()
        except curses.error:
            logger.exception("Could not create window %s to %s.", name)
            raise WindowError("Failed creating window: " + name)
        
    def getch(self):
        """Wrapper for cirses getch()"""
        return self.curses_window.getch()

    def get_size(self):
        """Get the size of the window"""
        size = list(self.curses_window.getmaxyx())
        size.reverse()                      #Swap y,x to x,y
        self.size = size
        
        return size
    
    def add_window(self, name, pos=list([0, 0]), size=list([10, 10])):
        """Create a new subwindow"""
        window = Window()

        try:
            window.curses_window = self.curses_window.derwin((size[1]
                                                              - window.border),
                                                             (size[0]
                                                              - window.border),
                                                             pos[1],  pos[0])
        
            window.create(name)
            window.pos = pos
            window.size = size
        except curses.error:       
            logger.exception("Could not add window %s to %s.", name,
                                    self.name)
            raise WindowError("Could not add window " + name + " to "\
                               + self.name)         
        else:
            self.windows.append(window)
            logger.info(window.name + " window created")
        
        return window 

    def set_title(self, title):
        """Set the title of the  window"""
        try:
            #Center the text on the line
            x_start = ((self.size[0] / 2) - (len(title) / 2)) + 1
            self.curses_window.addstr(0, x_start, " " + title + " ",  
                                      curses.color_pair(color.TITLE)
                                      + curses.A_BOLD)
            self.title = title
        except curses.error:
            logger.exception("Could not set title " + title + " of " \
                             + self.name)
            raise WindowError("Could not set title " + title + " of " \
                              + self.name)
        
    def close(self):
        """Destroy the window"""
        pass
    
def add_window(root, name, pos=list([0, 0]), size=list([10, 10])):
    """Create a new subwindow"""
    try:
        window = root.add_window(name, pos, size)
    except curses.error:       
        logger.exception("Could not add window %s to %s", name, root.name)
        raise WindowError("Could not add window " + name + " to " + root.name)
    else:
        logger.info(window.name + " window created")
    
    return window 
        
class _RootWindow(Window):
    """The curses root window."""
    def __init__(self):
        Window.__init__(self)
        self.name = "root" 
        try:
            self.curses_window = curses.initscr()
            curses.cbreak()
            curses.noecho()
            self.curses_window.keypad(1)
            
            #This is not nice! DiloagColors is in limbo until this call.
            #since curses color handling is uninitialized
            curses.start_color()
            
            color.WINDOW = color.add(color.black(), color.white())
            color.TITLE = color.add(color.yellow(), color.white())
            color.ROOT = color.add(color.cyan(), color.blue())

            self.curses_window.bkgd(" ", curses.color_pair(color.ROOT))
            
            self.get_size()
            
            curses.curs_set(0)
            
            self.border = 0
            
        except curses.error:
            logger.exception("Could not initialize root window.")
            self.close()
        else:
            logger.info("Root window created")    
        
      
    def set_title(self, title):
        """Set the title of the root window"""
        self.curses_window.addstr(0, 1, title,  
                                  curses.color_pair(color.ROOT)
                                  + curses.A_BOLD)
        for i in range(1, self.size[0] - 1):
            self.curses_window.addch(1, i, curses.ACS_HLINE,
                                curses.color_pair(color.ROOT)+ curses.A_BOLD)
        self.title = title

    def close(self):
        """Destroy the all windows"""
        for window in self.windows:
            logger.debug("Closing " + window.name + ".")
            window.close()
        self.curses_window.keypad(0)
        curses.endwin()
        
_root_window = _RootWindow()
def RootWindow():
    """Emulate a static class""" 
    return _root_window