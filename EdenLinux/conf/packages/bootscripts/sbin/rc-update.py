#!/usr/bin/env python
'''
Created on Nov 13, 2010

@author: oblivion

'''
import optparse
import os.path

def parse_lsb_header(filename, verbose = False):
    try:
        #Read the file
        with file(filename) as conf_file:
            lines = conf_file.read().splitlines()
        #Get the first line
        line = lines.pop(0)
        #Find the start tag
        while (not line.strip() == "### BEGIN INIT INFO") and (len(lines) > 0):
            line = lines.pop(0)
        #Parse the header if there is one
        if len(lines) > 0:
            #Get the first line after the start tag
            line = lines.pop(0)
            #Create a dictionary to hold the options
            LSB_options = dict()
            if verbose:
                print("Found LSB initscript header")
            #Parse the header until the end tag
            while ((not line.strip() == "### END INIT INFO")
                   and (len(lines) > 0)):
                #Split the line, to seperate name from value
                parts = line.split()
                value = ""
                spaced = False
                #Get the value
                for part in parts[2:]:
                    value += " "
                    value += part
                name = parts[1].replace(":", "")
                print("Adding: " + name + " = " + value)
                LSB_options[name] = value
                line = lines.pop(0)
            if verbose:
                print("Reached the end of the LSB initscript header")
    except IOError as ex:
        raise ex

def read_service_file(filename, verbose):
    services = dict()
    try:
        if verbose:
            print("Reading service file: " + filename)
        #Read the file
        with file(filename) as conf_file:
            lines = conf_file.read().splitlines()
        for line in lines:
            get_service = False
            name = ""
            if line.find("#") == 0:
                if line.find("Name:") > -1:
                    line.strip("#")
                    line.replace("Name:", "")
                    line.strip()
                    name = line
                    get_service = True
            elif get_service:
                services[name] = line
                if verbose:
                    print("Found service: " + name)
        return(services)
    except IOError as ex:
        raise ex

def add_service(service_name, service_dir, verbose):
    services = read_service_file(service_dir + "/start_services", verbose)
    print("Adding service: " + service_name)
    if service_name in services:
        print("Service all ready added to boot sequence")
        return

    script = "../../init.d/" + service_name

    lines.append("#!/bin/sh")
    lines.append("")
    lines.append("# Services Startup Script")
    lines.append("# This file is generated by rc-update, please do not edit this by hand")
    lines.append("")

    lines.append("#" + service_name)
    lines.append(script)

def remove_service(service_name, service_dir, verbose):
    print("Removing service: " + service_name)
    link = service_dir + "/start/" + service_name
    if verbose:
        print("Removing " + link)
    os.remove(link)
    link = service_dir + "/stop/" + service_name
    if verbose:
        print("Removing " + link)
    os.remove(link)

def main():
    """Main functions"""
    usage = "usage: %prog [options] service"
    parser = optparse.OptionParser(usage = usage, version = "0.5")
    parser.add_option("-v", "--verbose",
                      action = "store_true", dest = "verbose", default = False,
                      help = "Print detailed information")
    parser.add_option("-a", "--add",
                      action = "store_true", help = "Add a boot service")
    parser.add_option("-r", "--remove",
                      action = "store_true", help = "Remove a boot service")
    parser.add_option("-d", "--dir",
                      action = "store", type = "string", dest = "dir",
                      default = "/etc/rc.d",
                      help = "The directory where the init scripts are run (default: %default)")
    (options, args) = parser.parse_args()

    if not len(args) == 1:
        parser.print_help()
        return

    service_name = args[0]

    try:
        parse_lsb_header(options.dir + "/../init.d/" + service_name,
                         options.verbose)
        if options.add == True:
            add_service(service_name, options.dir, options.verbose)
        elif options.remove == True:
            remove_service(service_name, options.dir, options.verbose)
        else:
            parser.print_help()
            return
    except EnvironmentError as error:
        if error.filename == None:
            print(error.strerror)
        else:
            print(error.strerror + " accessing file: " + error.filename)

if __name__ == '__main__':
    main()
