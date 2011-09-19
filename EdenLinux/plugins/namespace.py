'''
Created on 6 Sep 2011

@author: oblivion
'''
def local_prefix():
    return(namespace.current.replace(".", "_").upper() + "_")

def local():
    print  local_prefix(),


def local_namespace(name):
    if name not in namespace.namespaces.keys():
        namespace.namespaces[name] = namespace.Namespace(name)

    namespace.current = name
