"""Loads a linux kernel like configuraton file

    $Id: dialogparser.py 183 2009-05-05 15:17:21Z oblivion $
"""
#I'm at my second pyton app, so i might be doing it C-style
import os
import string
from cursesui.logger import logger
import confdialog

class DialogParser:
    """ Class to parse a configuration conffile, and build a dialog from the
    data
    
    """
    def __init__(self):
        self.menudata = dict()
    
    def get_token(self, conffile):
        """Read the next token from the file"""
        token = ""
        
        try:
            #Strip leading spaces and the like
            while True:
                char = conffile.read(1)
                if ((not char in string.whitespace) or (len(char) ==0)):
                    break
                
            while True:
                if len(char) == 0:
                    return token   
                
                char = char.strip(string.whitespace + "\r\n")
                
                if len(char) == 0:
                    return token
                
                token += char
                char = conffile.read(1)
                
            conffile.seek(-1, os.SEEK_CUR)
                
        except IOError:
            logger.exception("Could not read token.")     

        return token
        
    def parse_string(self, conffile):
        """Read a string from the file."""
        confstr = ""
        try:            
            #Strip leading spaces and the like
            while True:
                char = conffile.read(1).strip(string.whitespace)
                if char == "\"":
                    break
                
            while True:
                char = conffile.read(1)
                #End of string, end of conffile?
                if (len(char) == 0) or (char == "\""):
                    break
                   
                #New line ?
                if len(char.strip("\r\n\t")) == 0:
                    #Strip whitespaces
                    while True:
                        char = conffile.read(1).strip(string.whitespace)
                        #Butt out when we're passed them 
                        if len(char) != 0:
                            char = " " + char
                            break
                        
                confstr += char.strip("\r\n\t")
                
        except IOError:
            logger.exception("Could not read string")
        
        return confstr
    
    def parse_name(self, conffile):
        """Read a name from the file"""
        name = ""
        try:
            #Strip leading spaces and the like
            while True:
                char = conffile.read(1).strip(string.whitespace)
                if len(char) != 0:
                    break
            
            conffile.seek(-1, os.SEEK_CUR)
                                                   
            line = conffile.readline().strip("\r\n")
            name = line
        except IOError:
            logger.exception("Could not read name")
        
        return name

    config_keywords = { "string": parse_string, "source": parse_string,
                        "help": parse_string }
    
    def parse_config(self, conffile):
        """Parses the whole file"""
        try:
            name = self.parse_name(conffile)
            self.menudata[name] = dict()
            
            #Set all options to empty
            for option in self.config_keywords:
                self.menudata[name][option] = ""
            
            fpos = conffile.tell()    
            while True:
                option = self.get_token(conffile)
                if len(option) == 0:
                    break

                option = option.strip(string.whitespace + "\r\n")
                if len(option) == 0:
                    break

                logger.debug( name + ":" + option + ":")
                logger.debug(self.config_keywords[option])
                self.menudata[name][option] = self.config_keywords[option] \
                                              (self, conffile).strip("\r\n")
                fpos = conffile.tell()
                
                #Create and load an object, for sourced conffiles
                if option == "source":
                    self.menudata[name]["submenu"] = DialogParser()
                    self.menudata[name]["submenu"].load(self.menudata[name]
                                                        [option])

        except KeyError:
            logger.exception("Cannot find %s in config_keywords.", option)
        
#Set the background title
    def parse_mainmenu(self, conffile):
        """Parse a mainmenu token"""
        self.menudata["mainmenu"] = self.parse_string(conffile).strip("\r\n")

    def parse_choice(self, conffile):
        """Parse a choice token"""
        pass
        
    def parse_comment(self, conffile):
        """Parse a comment"""
        pass
        
    def parse_menu(self, conffile):
        """Parse a menu token"""
        self.menudata["text"] = self.parse_string(conffile).strip("\r\n") 
        
    def parse_if(self, conffile):
        """Parse an if token"""
        pass
        
    def parse_source(self, conffile):
        """Parse source token"""
        conffile = open(self.parse_string(conffile).strip("\r\n"))
        self.load(conffile)
        conffile.close()
    
    keywords = {"config": parse_config, "mainmenu": parse_mainmenu,
                "charoice": parse_choice, "comment": parse_comment,
                "menu": parse_menu, "if": parse_if,
                "source": parse_source}
    
    #API
    def load(self, conffile):
        """Load a configuration file"""
        try:
            if isinstance(conffile, str):
                conffile = open( conffile, "r")
             
            while True:
                entry = self.get_token(conffile)
                if len(entry) == 0:
                    break
                        
                logger.debug(entry + ":")
                logger.debug(self.keywords[entry])
                
                self.keywords[entry](self, conffile)
                
        except KeyError:
            logger.exception("Unknown entry: %s.", entry)
            
        except IOError:
            logger.exception("Could not load %s.", conffile)
            
        return conffile          
            
    def close(self, conffile):
        """Cleanup"""
        conffile.close()
             
                    
    def show(self):
        """Show the configuration dialog"""
        #logger.logger.debug("show")
        
        conf_dialog = confdialog.ConfDialog()
        
        conf_dialog.create()
        
        conf_dialog.close()
