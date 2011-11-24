// rc-update is used to update the services started during boot.
package main

import (
	"flag"
	"fmt"
	"os"
	"io/ioutil"
	"strings"
	"container/list"
)

type BootService struct {
	Name      string
	LSBHeader map[string]string
}

type BootServices struct {
	StartList    *list.List
	StopList     *list.List
	MissingStart map[string]*list.List
	MissingStop  map[string]*list.List
}

var (
	verbose           = flag.Bool("verbose", false, "Print detailed information")
	addFlag           = flag.Bool("add", false, "Add a boot service")
	removeFlag        = flag.Bool("remove", false, "Remove a boot service")
	confDir           = flag.String("dir", "/etc", "The root configuration folder (default: /etc)")
	version    string = "0.4"
)

//Get service by name
func (bs *BootServices) GetService(name string) (service BootService, err os.Error) {
	var value BootService
	var node *list.Element

	for node = bs.StartList.Front(); node != nil; node = node.Next() {
		value = node.Value.(BootService)
		if value.Name == name {
			service = value
			break
		}
	}
	//If nothing's found
	if node == nil {
		err = os.NewError("Service not found: " + name)
	}
	return
}

//Parses the LSB header of an init script
func ParseLSBHeader(filename string) (service BootService, err os.Error) {
	if *verbose {
		fmt.Printf("Parsing LSB header in %s\n", filename)
	}
	service.LSBHeader = make(map[string]string)
	//Read the file
	confFile, error := ioutil.ReadFile(filename)
	if error != nil {
		err = error
		return
	}
	lines := strings.FieldsFunc(string(confFile), func(ch int) bool { return ch == '\n' })
	header := false
	i := 0
	line := ""
	for ; i < len(lines); i++ {
		line = lines[i]
		line = strings.Replace(line, "\n", "", -1)
		if line == "### BEGIN INIT INFO" {
			header = true
			break
		}
	}
	if !header {
		err = os.NewError("No LSB header found")
		return
	}
	if *verbose {
		fmt.Print("Found LSB initscript header\n")
	}
	//Parse the header until the end tag
	i++
	for ; lines[i] != "### END INIT INFO"; i++ {
		line = lines[i]
		if i == len(lines) {
			err = os.NewError("No LSB header end found")
			return
		}
		//Split the line, to separate name from value
		parts := strings.Fields(line)
		//Get the value
		if len(parts) > 2 {
			value := ""
			for j := 2; j < len(parts); j++ {
				value += " "
				value += parts[j]
			}
			name := strings.Replace(parts[1], ":", "", 1)
			if *verbose {
				fmt.Printf("Adding: %s = %s\n", name, value)
			}
			service.LSBHeader[name] = value
			if name == "Provides" {
				service.Name = strings.Replace(value, " ", "", -1)
			}
		}

	}
	if *verbose {
		fmt.Print("Reached the end of the LSB init script header\n")
	}
	return
}

//Add a service by reading its init script
func (bs *BootServices) Add(name, filename string) (err os.Error) {
	if *verbose {
		fmt.Printf("Adding service: %s\n", name)
	}
	service, error := ParseLSBHeader(filename)
	if error != nil {
		err = error
		return
	}
	service.Name = name
	//Insert in service list
	bs.InsertService(service)

	return
}

//Insert a node in the service list efter its dependencies
func (bs *BootServices) InsertService(service BootService) {
	_, err := bs.GetService(service.Name)
	if err != nil {
		InsertService(service, "Required-Start", bs.StartList, bs.MissingStart)
		InsertService(service, "Required-Stop", bs.StopList, bs.MissingStop)
	} else {
		if *verbose {
			fmt.Print("Service exists\n")
		}
	}
}

//Insert a node in the service list efter its dependencies
func InsertService(service BootService, depSection string, serviceList *list.List, missing map[string]*list.List) {
	//Insert the node in the service list
	//If the service has no dependencies add it to the end of the list
	deps, found := service.LSBHeader[depSection]
	if !found {
		serviceList.PushBack(service)
	} else {
		//The full blown treatment with dependency resolution
		//Create a slice of the dependencies
		var depList []string
		var dep string
		var activeService *list.Element
		depList = strings.Fields(service.LSBHeader[depSection])
		place := 0
		depIndex := 0
		found := false
		//Run through all dependencies and find the first place in the list,
		//Where they are fulfilled
		for depIndex = range depList {
			dep = depList[depIndex]
			serviceIdx := 0
			for activeService = serviceList.Front(); activeService != nil; activeService = activeService.Next() {
				if activeService.Value.(BootService).Name == dep {
					//If the new place is after the last found
					if serviceIdx > place {
						place = serviceIdx
					}
					found = true
					break
				}
				serviceIdx++
			}
		}
		if found {
			currentService := serviceList.InsertAfter(service, activeService)
			//Check if somebody else wants this service
			if depServices, found := missing[service.Name]; found {
				for depService := depServices.Front(); depService != nil; depService = depService.Next() {
					currentService = serviceList.InsertAfter(depService, currentService)
				}
				missing[service.Name] = nil, false
			}
		} else {
			//Add to service missing dependencies
			if *verbose {
				fmt.Printf("Adding service %s to list of services with unresolved dependencies\n", service.Name)
			}
			if depServices, found := missing[dep]; !found {
				missing[dep] = new(list.List)
			}
			missing[dep].PushBack(service)
		}
	}
}

//Read the file containing the service order
func readServiceFile(filename, scriptDir string) (services BootServices, err os.Error) {
	if *verbose {
		fmt.Printf("Reading service file: %s\n", filename)
	}
	services.StartList = list.New()
	services.StopList = list.New()
	services.MissingStart = make(map[string]*list.List)
	services.MissingStop = make(map[string]*list.List)
	//Read the fil eand split it into lines
	confFile, error := ioutil.ReadFile(filename)
	if error != nil {
		err = error
		return
	}
	lines := strings.FieldsFunc(string(confFile), func(ch int) bool { return ch == '\n' })
	getService := false
	name := ""
	for lineno := range lines {
		line := lines[lineno]
		if strings.Index(line, "#") == 0 {
			if strings.Index(line, "Name:") > -1 {
				name = strings.Replace(line, "#", "", -1)
				name = strings.Replace(name, "Name:", "", -1)
				name = strings.Replace(name, " ", "", -1)
				name = strings.Replace(name, "\n", "", -1)
				getService = true
			}
		} else if getService {
			getService = false
			service, error := ParseLSBHeader(scriptDir + "/" + name)
			if error != nil {
				err = error
				return
			}
			services.InsertService(service)
			if *verbose {
				fmt.Printf("Found service: %s\n", name)
			}
		}
	}
	return
}

//Write the file containing the service order
func writeServiceFile(path string, services BootServices) (err os.Error) {
	//Header
	if *verbose {
		fmt.Printf("Assembling service start file: %s/start_services\n", path)
	}
	lines := []string{"#!/bin/sh\n",
		"# Services Startup Script\n",
		"# This file is generated by rc-update, please do not edit this by hand\n"}
	for service := services.StartList.Front(); service != nil; service = service.Next() {
		value := service.Value.(BootService)
		if *verbose {
			fmt.Printf("Adding service: %s\n", value.Name)
		}
		lines = append(lines, "\n")
		line := "#Name: " + value.Name + "\n"
		lines = append(lines, line)
		line = "/etc/init.d/" + value.Name + "\n"
		lines = append(lines, line)
	}
	if *verbose {
		fmt.Printf("Writing service start file: %s/start_services\n", path)
	}
	confFile, err := os.Open(path+"/start_services", os.O_CREAT|os.O_RDWR, 0666)
	defer confFile.Close()
	for i := range lines {
		confFile.WriteString(lines[i])
	}
	//Header
	if *verbose {
		fmt.Printf("Assembling service stop file: %s/stop_services\n", path)
	}
	lines = []string{"#!/bin/sh\n",
		"# Services Shutdown Script\n",
		"# This file is generated by rc-update, please do not edit this by hand\n"}
	for service := services.StopList.Front(); service != nil; service = service.Next() {
		value := service.Value.(BootService)
		if *verbose {
			fmt.Printf("Adding service: %s\n", value.Name)
		}
		lines = append(lines, "\n")
		line := "#Name: " + value.Name + "\n"
		lines = append(lines, line)
		line = "/etc/init.d/" + value.Name + "\n"
		lines = append(lines, line)
	}
	if *verbose {
		fmt.Printf("Writing service stop file: %s/stop_services\n", path)
	}
	confFile, err = os.Open(path+"/stop_services", os.O_CREAT|os.O_RDWR, 0666)
	for i := range lines {
		confFile.WriteString(lines[i])
	}
	return
}

//Add a new service
func addService(serviceName, dir string) (err os.Error) {
	fmt.Printf("Adding service: %s\n", serviceName)
	serviceDir := dir + "/rc.d"
	services, error := readServiceFile(serviceDir+"/start_services", dir+"/init.d")
	if error != nil {
		err = error
		return
	}
	err = services.Add(serviceName, dir+"/init.d/"+serviceName)
	err = writeServiceFile(serviceDir, services)
	return
}

//Print command line help
func usage() {
	fmt.Fprintf(os.Stderr, "usage: rc-update [flags] service\n")
	flag.PrintDefaults()
	os.Exit(2)
}

//Main program entry point
func main() {
	fmt.Printf("rc-update for Eden Linux V.%s\n", version)
	flag.Usage = usage
	flag.Parse()

	if flag.NArg() != 1 {
		fmt.Print("Missing service name.\n\n")
		flag.Usage()
	}

	var serviceName = flag.Arg(0)

	if serviceName == "" {
		fmt.Print("Missing service name.\n\n")
		flag.Usage()
	}

	if *addFlag {
		error := addService(serviceName, *confDir)
		if error != nil {
			fmt.Printf("%s\n", error)
			os.Exit(2)
		}
	}
	if *removeFlag {
		//TODO: Code functions to remove services
		//fmt.Printf("Removing service: %s\n", serviceName)
		return
	}
	//
	//    try:
	//        if options.add == True:
	//            add_service(service_name, options.dir, options.verbose)
	//        elif options.remove == True:
	//            remove_service(service_name, options.dir, options.verbose)
	//        else:
	//            parser.print_help()
	//            return
	//    except EnvironmentError as error:
	//        if error.filename == None:
	//            print(error.strerror)
	//        else:
	//            print(error.strerror + " accessing file: " + error.filename)
}
//if __name__ == '__main__':
//    main()
