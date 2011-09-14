'''
Created on 2 Sep 2011

@author: oblivion
'''
import re
import log
import namespace
from namespace import namespaces

class Keywords(object):
    #namespace.set_current("global")
    keyword_re = re.compile(r'\$\{([a-zA-Z-_]+)([\S \t]*)}')

    def render(self, template):
        keyword_split = list()
        for entity in template:
            if isinstance(entity, str):
                #Ignore keywords in comments
                if entity.lstrip().find("#") == 0:
                    log.logger.debug("Ignoring: " + entity)
                    keyword_split += entity
                else:
                    keyword_split += self.keyword_re.split(entity)
                    log.logger.debug("Isolating keyword(s) in: " + entity)
        ret = list()
        last_entity = ""
        for entity in keyword_split:
            #Check for parameters if last entity was a keyword
            if len(last_entity) > 0:
                if entity.find("(") == 0:
                    entity = last_entity + entity + "}"
                else:
                    entity = last_entity + "()}"
                log.logger.debug("Final keyword: " + entity)
                ret.append(entity)
                last_entity = ""
            else:
                #Check for a keyword
                if entity in namespaces[namespace.current].env.keys():
                    if callable(namespaces[namespace.current].env[entity]):
                        log.logger.debug("Found keyword: " + entity)
                        #Because of the way the regexp is set to split things
                        #the parameters if any will come in the next pass
                        #therefore save the entity until we can check for this
                        last_entity = "${py " + entity
                        log.logger.debug("Saving keyword part: " + last_entity)
                    else:
                        log.logger.debug("Found variable: " + entity)
                else:
                    ret.extend([entity])
        return(ret)

keywords = Keywords()
