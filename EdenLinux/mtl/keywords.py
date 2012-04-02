'''
Created on 2 Sep 2011

@author: oblivion
'''
import re
import log
import namespace
from namespace import namespaces

class Keywords(object):
    '''Class to handle template keywords.'''
    keyword_re = re.compile(r'\$\{(?!py )([a-zA-Z-_]+)([\S \t]*)}')
    '''Compiled regular expression to find keywords.'''
    def render(self, template):
        '''
        Render the keywords.
        
        @type template: list
        @param template: List of lines of text in the template.
        @rtype: list
        @return: List of lines in the resulting template. 
        '''
        ret = list()
        for entity in template:
            while len(entity) > 0:
                line = ""
                #Ignore comments
                if not entity.lstrip().find("#") == 0:
                    if not entity.find("${") == -1:
                        start = entity.find("${") + 2
                        #Save everything before the keyword
                        line += entity[:start]
                        inline = ""
                        #Add convert keyword to inline
                        if not entity.find("py") == start:
                            inline += "py print str("
                        #Find the end of the tag
                        end = entity.find("}")
                        #Put back the tag
                        inline += entity[start:end]
                        if not entity.find("py") == start:
                            inline += "),"
                        inline += "}"
                        log.logger.debug("Found: " + entity[start:end])
                        line += inline
                        entity = entity.replace(entity[:end + 1], '')
                line += entity
                ret.append(line)
                entity = ""
        return(ret)


keywords = Keywords()
'''Instance of the Keywords class, for use with L{inline.Inline}.'''
