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
#        #Split template by keywords
#        keyword_split = list()
#        for entity in template:
#            if isinstance(entity, str):
#                #Ignore keywords in comments
#                if entity.lstrip().find("#") == 0:
#                    log.logger.debug("Ignoring: " + entity)
#                    keyword_split += entity
#                else:
#                    log.logger.debug("Isolating keyword(s) in: " + entity)
#                    keyword_split += self.keyword_re.split(entity)
#
#        ret = list()
#        last_entity = ""
#        for entity in keyword_split:
#            #Check for parameters if last entity was a keyword
#            if len(last_entity) > 0:
##TODO See comment in plugins/namespave.py
#                if not last_entity.find("local_namespace") == -1:
#                    #Namespace change get the new namespace
#                    name = entity.split('"', 2)[1]
#                    namespace.set_current(name)
#                if entity.find("(") == 0:
#                    entity = last_entity + entity + "}"
#                else:
#                    entity = last_entity + entity + "),}"
#                log.logger.debug("Final python tag: " + entity)
#                ret.append(entity)
#                last_entity = ""
#            else:
#                #Check for a keyword
#                if entity in namespaces[namespace.current].env.keys():
#                    if callable(namespaces[namespace.current].env[entity]):
#                        log.logger.debug("Found keyword: " + entity)
#                        #Because of the way the regexp is set to split things
#                        #the parameters if any will come in the next pass
#                        #therefore save the entity until we can check for this
#                        last_entity = "${py " + entity
#                        log.logger.debug("Saving keyword part: " + last_entity)
#                    else:
#                        log.logger.debug("Found variable part: " + entity)
#                        last_entity = "${py print str(" + entity
#                else:
#                    ret.extend([entity])
#        return(ret)

keywords = Keywords()
'''Instance of the Keywords class, for use with L{inline.Inline}.'''
