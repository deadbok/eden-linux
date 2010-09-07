#!/usr/bin/env python
'''
Created on Sep 7, 2010

@author: oblivion

Quickly hacked tool to find the archive type of a file from the extension, and unpack it 
'''
import optparse
import os.path
import os

#Dict of decompressors, and their calling convention
decompressors = { ".bz2": ["tar", "$verbose -v", "-xjf", "$packed_filename", "-C", "$destination"],
                  ".gz": ["tar", "$verbose -v", "-xzf", "$packed_filename", "-C", "$destination"]}

def main():
    """Main functions"""
    usage = "usage: %prog [options] packed_filename unpack_dir"
    parser = optparse.OptionParser(usage = usage)
    parser.add_option("-v", "--verbose",
                      action = "store_true", dest = "verbose", default = False,
                      help = "Print detailed progress")

    (options, args) = parser.parse_args()

    if len(args) < 2:
        parser.print_help()
        return

    filename = args[0]
    destination = args[1]

    print('uunpack unpacking "' + filename + '" to "' + destination)
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
    else:
        print("Unknown extension: " + extension[1])

if __name__ == '__main__':
    main()
