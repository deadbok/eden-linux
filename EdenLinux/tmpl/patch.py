'''
Created on 9 Sep 2011

@author: oblivion
'''
def patchall(deps):
    '''Apply all patches to sources in current namespace.
    
    @param deps: Additional dependencies are set using this string
    @type deps: str
    '''
    patch_dir = "$(ROOT)/" + namespace.current.replace(".", "/")
    print var_name("patchall") + " := $(" + var_name("src_dir") + ")/.patched"
    print "$(" + var_name("patchall") + "): " + deps
    print "\t$(foreach PATCHFILE, $(wildcard " + patch_dir + "/*.patch), patch -p1 -d $(" + var_name("src_dir") + ") < $(PATCHFILE);)"
    print "\t$(TOUCH) $(" + var_name("patchall") + ")",
