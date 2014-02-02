'''
pkg-solver
@since: 30/01/2014
@author: oblivion
@version: 0.3

Given a file with a list of packages, output a list of packages to build
ordered by dependencies.

Version 0.32 January 31, 2014
Fixed regexp bug.

Version 0.31 January 31, 2014:
Fixed an indentation bug.

Version 0.3 January 30, 2014:
First version.
'''
VERSION = '0.32'

import argparse
import re
import sys

ARGS = None


def get_dependencies(filename, package_directory):
    '''Get the dependencies of a package.'''
    full_filename = package_directory + '/' + filename
    if (ARGS.verbose > 1):
        print('Reading: ' + full_filename)
    with open(full_filename) as pkg_file:
        # Isolate the depenendy line
        depline = re.findall(r'_DEPENDENCIES .*', pkg_file.read())
        # No dependencies
        if len(depline) == 0:
            # Return empty list
            ret = list()
        else:
            # Isolate the dependencies
            make_dep = re.findall(r'\$\(([A-Z0-9_]*)\)', depline[0])
            # Convert from make notation to full_filename
            dependencies = list()
            for dependency in make_dep:
                # Convert to lower case
                dependency = dependency.lower()
                # Remove packages_ part
                dependency = dependency.replace('packages_', '')
                # Remove _install part
                dependency = dependency.replace('_install', '')
                # Replace _ with / and add .mk
                dependency = dependency.replace('_', '/') + '.mk'
                dependencies.append(dependency)
            # Return list of dependencies
            ret = dependencies

    if (ARGS.verbose > 2):
        print('Dependencies: ' + str(ret))
    return(ret)


def read_list(filename, package_directory):
    '''Read a file with a list of file names (sans extension).'''
    # Open file
    with open(filename) as listfile:
        packages = dict()
        # Read each filename
        for name in listfile:
            name = name.strip()
            # Ignore empty lines
            if (name != ""):
                name = name + '.mk'
                # Create a dictionary with filenames as key, and an empty list of
                # dependencies
                try:
                    packages[name] = get_dependencies(name, package_directory)
                except IOError as exception:
                    print('Cannot read package file ' + name +
                          ' needed by the package list')
                    print(exception.strerror)
                    sys.exit(1)

    return(packages)


def solve_dep(packages, package_directory):
    '''Solve package dependencies and return a sorted list.'''
    # First expand package list to include dependencies
    if (ARGS.verbose > 0):
        print('Expanding package list with dependencies.')
    # Run through all packages and add dependencies to the dict
    done = False
    while(done != True):
        # Hope that we're through
        done = True
        # Run through all packages
        for filename, package in packages.items():
            # for each dependency
            for dep in package:
                if dep not in packages.keys():
                    if (ARGS.verbose > 2):
                        print('Adding: ' + dep)
                        # We need another run
                    done = False
                    try:
                        packages[dep] = get_dependencies(dep,
                                                         package_directory)
                    except IOError as exception:
                        print('Cannot read package file ' + dep +
                              ' needed by ' + filename)
                        print(exception.strerror)
                        sys.exit(1)

    # Sort the full list of packages
    if (ARGS.verbose > 0):
        print('Sorting the full package list.')
    done = False
    # List of installed packages at the current step
    installed_packages = list()
    while(done != True):
        # Hope that we're through
        done = True

        # For every package
        for filename, package in packages.items():
            # Check if it is installed
            if filename not in installed_packages:
                # If package has no dependencies just add it
                if (len(package) == 0):
                    installed_packages.append(filename)
                    if (ARGS.verbose > 1):
                        print('Adding: ' + filename)
                else:  # Else check them
                    # We assume all dependencies solved
                    solved = True
                    # Run through each dependency
                    for dep in package:
                        # If dependency is not installed
                        if dep not in installed_packages:
                            # Not solved
                            solved = False
                            # We need another run
                            done = False
                            if (ARGS.verbose > 2):
                                print('Not adding: ' + filename)
                    if solved:
                        installed_packages.append(filename)
                        if (ARGS.verbose > 1):
                            print('Adding: ' + filename)

    return(installed_packages)


def write_list(filename, sorted_list):
    '''Write the list in make format.'''
    # Open file
    try:
        with open(filename, 'w') as listfile:
            for name in sorted_list:
                listfile.write('include packages/' + name + '\n')
                if (ARGS.verbose > 0):
                    print('package: ' + name)
    except IOError as exception:
        print('Cannot write list file ' + filename)
        print(exception.strerror)
        sys.exit(1)


def main():
    '''Main entry point.'''
    global ARGS

    parser = argparse.ArgumentParser()
    print(parser.prog + ' version ' + VERSION + '\n')

    # Add options
    parser.add_argument("-v", "--verbose", help="increase shouting", action='count')
    parser.add_argument('package_directory', help='Path to the package files')
    parser.add_argument('input_list_filename', help='Name of a file with a list of packages')
    parser.add_argument('output_list_filename', help='Name of a file to write a list of packages to')

    ARGS = parser.parse_args()

    print('Reading package list: ' + ARGS.input_list_filename)
    packages = read_list(ARGS.input_list_filename, ARGS.package_directory)

    print('Solving dependencies...')
    sorted_list = solve_dep(packages, ARGS.package_directory)

    output_filename = ARGS.package_directory + '/' + ARGS.output_list_filename
    print('Writing list to: ' + output_filename)
    write_list(output_filename, sorted_list)

if __name__ == '__main__':
    main()
