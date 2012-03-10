'''
@since 12 Jan 2012
@author: oblivion
'''
import urwid


class CustomButton(urwid.Button):
    '''
    Class to act sort of like a link to a sub-page.
    '''
    def __init__(self, label, left=None, right=None):
        '''
        Constructor.
        '''
        self.left_text = None
        self.right_text = None
        self.text_widgets = list()
        #Construct the button
        urwid.Button.__init__(self, label)
        #Create text widgets for the decoration
        if left != None:
            self.left_text = urwid.Text(left)
            self.text_widgets.append(('fixed', 1, self.left_text))
        self.text_widgets.append(self._label)
        if right != None:
            self.right_text = urwid.Text(right)
            self.text_widgets.append(('fixed', 1, self.right_text))
        #Use the decoration by overriding the wrapped widget
        self._wrapped_widget = urwid.Columns(self.text_widgets, dividechars=1)
