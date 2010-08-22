#!/usr/bin/env python
#I'm at my second pyton app, so i might be doing it C-style
import optparse
import dialogparser

def main():
    """Main function"""
    dialog_parser = dialogparser.DialogParser()
    
    usage = "usage: %prog [options] dialog-file"
    arg_parser = optparse.OptionParser(usage=usage)
    arg_parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose", default=True,
                      help="Print detailed progress [default]")
    
    (options, args) = arg_parser.parse_args()
    
    if len(args) == 0:
        arg_parser.print_help()
        return
    
    conf_file = dialog_parser.load(args[0])
    dialog_parser.show()
    dialog_parser.close(conf_file)

if __name__ == "__main__":
    main()
