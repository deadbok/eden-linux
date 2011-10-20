#!/usr/bin/env python
'''
Created on Nov 13, 2010

@author: oblivion

'''
import optparse
import os.path

class BootService(object):
    '''
    classdocs
    '''


    def __init__(self, name = ""):
        '''
        Constructor
        '''
        self.name = name
        self.next = None
        self.LSB_header = dict()

class BootServices(object):
    '''
    Class to create a list of the services in the correct order, specified in
    LSB header
    '''

    def __init__(self, verbose = False):
        '''
        Constructor
        '''
        self.start_list = list()
        self.stop_list = list()
        self.verbose = verbose
        self.missing_start = dict()
        self.missing_stop = dict()

    def parse_lsb_header(self, filename):
        '''
        Parses the LSB header of an init script
        '''
        try:
            #Create a dictionary to hold the options
            LSB_options = dict()
            #Read the file
            with file(filename) as conf_file:
                lines = conf_file.read().splitlines()
            #Get the first line
            line = lines.pop(0)
            #Find the start tag
            while ((not line.strip() == "### BEGIN INIT INFO") and
                   (len(lines) > 0)):
                line = lines.pop(0)
            #Parse the header if there is one
            if len(lines) > 0:
                #Get the first line after the start tag
                line = lines.pop(0)
                if self.verbose:
                    print("Found LSB initscript header")
                #Parse the header until the end tag
                while ((not line.strip() == "### END INIT INFO")
                       and (len(lines) > 0)):
                    #Split the line, to separate name from value
                    parts = line.split()
                    value = ""
                    #Get the value
                    for part in parts[2:]:
                        value += " "
                        value += part
                    name = parts[1].replace(":", "")
                    if self.verbose:
                        print("Adding: " + name + " = " + value)
                    LSB_options[name] = value
                    line = lines.pop(0)
                if self.verbose:
                    print("Reached the end of the LSB init script header")
                return(LSB_options)
            if len(LSB_options) == 0:
                raise SyntaxError("No LSB header found in: " + filename)
        except IOError as ex:
            raise ex

    def get_service(self, name):
        '''
        Get service by name
        '''
        for node in self.start_list:
            if node.name == name:
                return(node)
        return(None)

    def add(self, name, filename):
        """
        Add a service by reading its init script
        """
        service = BootService()
        service.name = name
        if self.verbose:
            print("Adding service_list: " + name)
        service.LSB_header = self.parse_lsb_header(filename)
        #Insert the node in the start list
        #The node has no dependencies, just add to the end
        if "Required-Start" not in service.LSB_header:
            self.start_list.append(service)
        else:
            #The full blown treatment with dependency resolution
            deps = service.LSB_header["Required-Start"].split()
            place = 0
            dep_index = 0
            found = True
            #Run through all dependencies and find the first place in the list,
            #Where they are fulfilled
            while ((found) & (len(deps) > dep_index)):
                dep = deps[dep_index]
                i = 0
                found = False
                for req_service in self.start_list:
                    if req_service.name == dep:
                        #If the new place is after the last found
                        if i > place:
                            place = i
                            found = True
                    i += 1
                dep_index += 1
            if found:
                place += 1
                self.start_list.insert(place, service)
                #Check if somebody else wants this service
                if name in self.missing_start:
                    for dep_service in self.missing_start[name]:
                        place += 1
                        self.start_list.insert(place, dep_service)
                    del self.missing_start[name]
            else:
                #Add to service missing dependencies
                if dep not in self.missing_start:
                    self.missing_start[dep] = list()
                self.missing_start[dep].append(service)

        #Insert the node in the stop list
        #The node has no dependencies, just add to the end
        if "Required-Stop" not in service.LSB_header:
            self.stop_list.append(service)
        else:
            #The full blown treatment with dependency resolution
            deps = service.LSB_header["Required-Stop"].split()
            place = 0
            dep_index = 0
            found = True
            #Run through all dependencies and find the first place in the list,
            #Where they are fulfilled
            while ((found) & (len(deps) > dep_index)):
                dep = deps[dep_index]
                i = 0
                found = False
                for req_service in self.start_list:
                    if req_service.name == dep:
                        #If the new place is after the last found
                        if i > place:
                            place = i
                            found = True
                    i += 1
                dep_index += 1
            if found:
                self.stop_list.insert(place, service)
                #Check if somebody else wants this service
                if name in self.missing_stop:
                    for dep_service in self.missing_stop[name]:
                        self.stop_list.insert(place, dep_service)
                    del self.missing_stop[name]
            else:
                #Add to service missing dependencies
                if dep not in self.missing_stop:
                    self.missing_stop[dep] = list()
                self.missing_stop[dep].append(service)


def read_service_file(filename, verbose):
    '''
    Read the file with the current service order 
    '''
    services = BootServices(verbose)
    try:
        if verbose:
            print("Reading service file: " + filename)
        #Figure out the path to the init scripts
        path = os.path.dirname(filename).replace("/etc/rc.d", "")
        #Read the file
        with open(filename) as conf_file:
            lines = conf_file.read().splitlines()
        get_service = False
        for line in lines:
            if line.find("#") == 0:
                if line.find("Name:") > -1:
                    name = line.strip("#")
                    name = name.replace("Name:", "")
                    name = name.strip()
                    get_service = True
            elif get_service:
                get_service = False
                services.add(name, path + line)
                if verbose:
                    print("Found service: " + name)
                name = ""
        return(services)
    except IOError as ex:
        raise ex

def write_service_file(path, services, verbose):
    '''
    Write the file with the current service order 
    '''
    #Header
    if verbose:
        print("Assembling service start file: " + path + "/start_services")
    lines = [ '#!/bin/sh\n',
             '# Services Startup Script\n',
             '# This file is generated by rc-update, please do not edit this by hand\n' ]
    for service in services.start_list:
        lines.append('\n')
        lines.append('#Name: ' + service.name + "\n")
        lines.append('/etc/init.d/' + service.name + "\n")
        if verbose:
            print("Adding service: " + service.name)

    if verbose:
        print("Writing service start file: " + path + "/start_services")
    with open(path + "/start_services", 'w') as conf_file:
        conf_file.writelines(lines)
    #Header
    if verbose:
        print("Assembling service stop file: " + path + "/stop_services")
    lines = [ '#!/bin/sh\n',
             '# Services Shutdown Script\n',
             '# This file is generated by rc-update, please do not edit this by hand\n' ]
    for service in services.stop_list:
        lines.append('\n')
        lines.append('#Name: ' + service.name + "\n")
        lines.append('/etc/init.d/' + service.name + "\n")
        if verbose:
            print("Adding service: " + service.name)

    if verbose:
        print("Writing service stop file: " + path + "/stop_services")
    with open(path + "/stop_services", 'w') as conf_file:
        conf_file.writelines(lines)

def add_service(service_name, config_dir, verbose):
    service_dir = config_dir + "/rc.d"
    print("Adding service: " + service_name)
    services = read_service_file(service_dir + "/start_services", verbose)
    if not services.get_service(service_name) == None:
        print("Service all ready added to boot sequence")
        return
    services.add(service_name, config_dir + "/init.d/" + service_name)
    write_service_file(service_dir, services, verbose)

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
                      default = "/etc",
                      help = "The root configuration folder (default: %default)")
    (options, args) = parser.parse_args()

    if not len(args) == 1:
        parser.print_help()
        return

    service_name = args[0]

    try:
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
