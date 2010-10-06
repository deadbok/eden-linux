"""A simple textbox"""
import curses
from logger import logger
import window
import color

class TextBox(window.Window):
    """A simple text box.""" 
    def __init__(self):
        """Init he textbox."""
        window.Window.__init__(self)
        
        self.text = ""
        
    def create(self, name):
        """Create a new textbox."""
        self.name = name
        self.curses_window.bkgd(" ",
                                curses.color_pair(color.WINDOW))
      
    def add_textbox(self, name, text, pos=list([0, 0]), size=list([10, 10])):
        """Create a new add a textbox as sub window"""
        textbox = TextBox()

        try:
            textbox.curses_window = self.curses_window.derwin((size[1]
                                                              - textbox.border),
                                                             (size[0]
                                                              - textbox.border),
                                                             pos[1],  pos[0])
        
            textbox.create(name)
            textbox.pos = pos
            textbox.size = size
            textbox.text = text
        except curses.error:       
            logger.exception("Could not add textbox %s to %s", name, self.name)
        else:
            self.windows.append(textbox)
            logger.info(textbox.name + " textbox created")
        
        return textbox 

    def show_text(self):
        """Show the text"""
        self.curses_window.addstr(0, 0, self.text,  
                                  curses.color_pair(color.WINDOW)
                                  )
                
def add_textbox(root, name, text, pos=list([0, 0]), size=list([10, 10])):
    """Create a new textbox as a child of root"""
#    textbox = TextBox()

#    try:
#        textbox.curses_window = root.curses_window.derwin((size[1]
#                                                          - textbox.border),
#                                                         (size[0]
#                                                          - textbox.border),
#                                                         pos[1],  pos[0])
    
#        textbox.create(name)
#        textbox.pos = pos
#        textbox.size = size
#        textbox.text = text
#    except curses.error:       
#        logger.exception("Could not add textbox %s to %s", name, root.name)
#    else:
#        root.windows.append(textbox)
#        logger.info(textbox.name + " textbox created")
    
    return textbox    