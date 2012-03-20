'''
Main program.

@since: Jan 21, 2011
@author: oblivion
'''
import urwid
import log
import logging
import loader
import writer
import optparse
import ui.configdisplay

#Jan 10, 2012 version 0.2:
#    Basic UI in place.
VERSION = 0.2


class App(object):
    '''Class with main application control.'''
    def __init__(self):
        '''Constructor.'''
        self.loader = None
        self.display = None
        self.loop = None
        self.writer = None

    def handle_global(self, key):
        '''
        Handle keys, that are not handled by the widgets.

        @param key: The key which has been pressed.
        @type key: str
        '''
        if key == 'esc':
            log.logger.debug("ESC pressed")
            self.display.body.original_widget.original_widget.page_back()
        return(True)

    def handle_save(self, widget, *args):
        log.logger.debug("Saving to: " + self.loader.dir)
        self.writer = writer.Writer(self.loader.dir)
        self.writer.save_tree(self.loader.config_tree)


    def run(self, makefiles_dir):
        '''Do your stuff please...
        @param makefiles_dir: Path to find the make files
        @type makefiles_dir: str
        '''
        self.loader = loader.Loader(makefiles_dir)
        self.display = ui.configdisplay.ConfigDisplay(self.loader)
        urwid.connect_signal(self.display, 'save', self.handle_save)
        self.loop = urwid.MainLoop(self.display, self.display.palette,
                              unhandled_input=self.handle_global, pop_ups=True)
        screen_size = self.loop.screen.get_cols_rows()
        log.logger.debug("Screen size: " + str(screen_size))
        self.loop.run()


app = App()


def main():
    '''Main entry point.'''
    usage = "usage: %prog [options] [Make files directory]"
    arg_parser = optparse.OptionParser(usage=usage)
    arg_parser.add_option("-v", "--verbose",
                          action="store_true", dest="verbose",
                          default=False,
                          help="Print detailed progress [default]")
    arg_parser.add_option("-l", "--log-level",
                          type="int", default=2,
                          help="Set the logging level for the log files (0-5)"
                          )
    (options, args) = arg_parser.parse_args()
    if len(args) == 0:
        arg_parser.print_help()
        return
    if options.log_level == 0:
        log.init_file_log(logging.NOTSET)
    elif options.log_level == 1:
        log.init_file_log(logging.DEBUG)
    elif options.log_level == 2:
        log.init_file_log(logging.INFO)
    elif options.log_level == 3:
        log.init_file_log(logging.WARNING)
    elif options.log_level == 4:
        log.init_file_log(logging.ERROR)
    elif options.log_level == 5:
        log.init_file_log(logging.CRITICAL)
    else:
        log.init_file_log(logging.INFO)
    if options.verbose:
        log.init_console_log(logging.DEBUG)
    else:
        log.init_console_log()
    #Save the config path
    makefiles_dir = args[0]

    log.logger.info("Make configuration console UI V" + str(VERSION))

    app.run(makefiles_dir)

    log.logger.info("Done.")
    log.close_log()

if __name__ == '__main__':
    main()
