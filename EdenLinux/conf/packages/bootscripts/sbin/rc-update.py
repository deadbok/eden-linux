#!/usr/bin/env python
'''
Created on Nov 13, 2010

@author: oblivion

'''
import optparse
import os.path
#import os

def main():
    """Main functions"""
    usage = "usage: %prog [options] service"
    parser = optparse.OptionParser(usage = usage)
    parser.add_option("-v", "--verbose",
                      action = "store_true", dest = "verbose", default = False,
                      help = "Print detailed information")
    parser.add_option("-a", "--add",
                      action = "store_true", dest = "add", default = False,
                      help = "Add a boot service")
    parser.add_option("-r", "--remove",
                      action = "store_true", dest = "rem", default = False,
                      help = "Remove a boot service")

    (options, args) = parser.parse_args()

    if len(args) < 2:
        parser.print_help()
        return

    filename = args[0]
    destination = args[1]

    print('uunpack unpacking "' + filename + '" to "' + destination + '"')
    extension = os.path.splitext(filename)
    if options.verbose:
        print('Determining archive format from extension: ' + extension[1])

    cmd = ""
    if extension[1] in decompressors:
        for cmd_part in decompressors[extension[1]]:
            if cmd_part.find("$verbose") > -1:
                if options.verbose:
                    cmd += cmd_part.replace("$verbose", "")
            elif cmd_part.find("$packed_filename") > -1:
                cmd += filename
            elif cmd_part.find("$destination") > -1:
                cmd += destination
            else:
                cmd += cmd_part

            cmd += " "

        print("Command line: " + cmd)
        os.system(cmd)
        command = "touch " + destination + "/.unpacked"
        os.system(command)
    else:
        print("Unknown extension: " + extension[1])

if __name__ == '__main__':
    main()
