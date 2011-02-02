'''
Created on 2 Jan 2011

@author: oblivion
'''
from BootService import BootService

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


