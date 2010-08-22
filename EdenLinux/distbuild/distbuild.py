#!/usr/bin/env python
import optparse

def main():
    """Main function"""

    usage = "usage: %prog [options] dialog-file"
    arg_parser = optparse.OptionParser(usage = usage)
    arg_parser.add_option("-v", "--verbose",
                      action = "store_true", dest = "verbose", default = True,
                      help = "Print detailed progress [default]")

    (options, args) = arg_parser.parse_args()

    if len(args) == 0:
        arg_parser.print_help()
        return

if __name__ == "__main__":
    main()
