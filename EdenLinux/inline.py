'''
Created on 2 Sep 2011

@author: oblivion
'''
import re
import sys
from StringIO import StringIO
import log
import keywords
import namespace


def repl(matchobj):
    log.logger.debug("Found in-line code: " + matchobj.group(1))
    buf = StringIO()
    sys.stdout = buf
#    env = dict()
#    env.update(namespace.namespaces[namespace.current].env)
#    env.update(namespace.namespaces["global"].env)
#TODO: Make sure the dictionaries are passed in the right order for new variables to be created in the local namespace
    exec matchobj.group(1) in namespace.namespaces["global"].env, namespace.namespaces[namespace.current].env
    #remember to restore the original stdout!
    sys.stdout = sys.__stdout__

    return(buf.getvalue())

class Inline(object):
    '''Base class for inline templates'''
    #${*}
    inline_re = re.compile(r'\$\{py\s+(.+)}')

    def __init__(self, template):
        self.template = template
        self.processed = template

    def substitute(self, mapping):
        '''Substitute
        
        @type value: mapping type
        @param value: The value to convert
        '''
        namespace.set_current("global")
        self.processed = mapping.render(self.template)

        ret = list()
        for entity in self.processed:
            if isinstance(entity, str):
                keyword_sub = self.inline_re.sub(repl, entity)
                ret.append(keyword_sub)
        self.processed = ret
        return(ret)
