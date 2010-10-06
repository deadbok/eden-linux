#!/usr/bin/env python
'''
Created on Sep 12, 2010

@author: oblivion

Quickly hacked tool to apply all patches in a directory to a source tree 
'''
import optparse
import os.path
import os

def main():
    """Main functions"""
    usage = "usage: %prog [options] patch_dir source_dir"
    parser = optparse.OptionParser(usage = usage)
    parser.add_option("-v", "--verbose",
                      action = "store_true", dest = "verbose", default = False,
                      help = "Print detailed progress")

    (options, args) = parser.parse_args()

    if len(args) < 2:
        parser.print_help()
        return

    patch_dir = args[0]
    source_dir = args[1]

    print('patchall patching "' + source_dir + '" with patches in "' + patch_dir + '"')
    try:
        for entry in os.listdir(patch_dir):
            if os.path.isfile(patch_dir + "/" + entry):
                if os.path.splitext(entry)[1] == ".patch":
                    print("Patching with: " + entry)
                    command = "patch -p1 -d " + source_dir + " < " + patch_dir + "/" + entry
                    if options.verbose:
                        print('Running: ' + command)
                    os.system(command)
        command = "touch " + source_dir + "/.patched"
        os.system(command)

    except IOError as e:
        print('Exception: "' + e.strerror + '" accessing file: ' + patch_dir + "/" + entry)
    except OSError as e:
        print('Exception: "' + e.strerror + '" accessing file: ' + patch_dir)

if __name__ == '__main__':
    main()
