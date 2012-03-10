'''
Template level namespace handling.

@since 6 Sep 2011
@author: oblivion
'''
def local():
    return(namespace.current.replace(".", "_").upper() + "_")


#TODO: Until I find a better solution, this function IS EXPECTED to be present
#mtl/keywords.py need this to know when it's time for a namespace change
def local_namespace(name):
    #Only lower case letters allowed
    name = name.lower()
    if name not in namespace.namespaces.keys():
        namespace.namespaces[name] = namespace.Namespace(name)

    namespace.current = name
    return("")


def var_name(postfix=None, make_var=False):
    '''
    Return a variable, with the right prefix to make it local in the make file.

    @param postfix: A variable name to get, in the local namespace.
    @type postfix: str
    '''
    ret = ""
    if postfix == None:
        ret = local()
    else:
        ret = local() + postfix.upper()
    if make_var:
        ret = "$(" + ret + ")"
    return(ret)
