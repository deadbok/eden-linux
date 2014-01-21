'''
Created on 2 Sep 2011

@author: oblivion
'''
import re
import sys
from StringIO import StringIO
import log
import namespace


def repl(matchobj):
    '''
    repl function for re.RegexObject.sub().
    
    @type matchobj: re.MatchObject
    @param matchobj:  MatchObject from re.RegexObject.sub().
    '''
    log.logger.debug("Found in-line code: " + matchobj.group(1))
    buf = StringIO()
    sys.stdout = buf
    env = dict()
    env.update(namespace.namespaces[namespace.current].env)
    env.update(namespace.namespaces["global"].env)
#TODO: Make sure the dictionaries are passed in the right order for new variables to be created in the local namespace
    log.logger.debug("Calling: " + matchobj.group(1))
    exec matchobj.group(1) in env
    namespace.namespaces[namespace.current].env.update(env)
    #remember to restore the original stdout!
    sys.stdout = sys.__stdout__
    ret = buf.getvalue().rstrip("\n")
    log.logger.debug("Return: " + ret)
    return(ret)

class Inline(object):
    '''Class to handle in line templates'''
    #${*}
    inline_re = re.compile(r'\$\{py\s+([^}]+)\}')

    def __init__(self, template):
        '''
        Constructor.
        
        @type template: list
        @param template: List of lines of text in the template.
        '''
        self.template = template
        self.processed = template

    def substitute(self, keywords):
        '''Perform template substitution.
        
        @type keywords: L{keywords.Keywords}
        @param keywords: Class to process special keywords
        '''
        #Reset namespace
        namespace.set_current("global")
        #Render keywords
        self.processed = keywords.render(self.template)

        ret = list()
        for entity in self.processed:
            if isinstance(entity, str) and entity != "":
                #Skip comments
                if not entity.startswith("#"):
                    keyword_sub = self.inline_re.sub(repl, entity)
                    if not keyword_sub == "":
                        ret.extend(keyword_sub.splitlines(True))
                else:
                    ret.extend(entity)
        self.processed = ret
        return(ret)
