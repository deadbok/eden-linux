'''
Patch functions.

@since: 9 Sep 2011
@author: oblivion
'''
class Patch(object):
    '''Class to generate recipes for calling make'''
    def __str__(self):
        '''Stringify patching'''
        patch_dir = "$(ROOT)/" + namespace.current.replace(".", "/")

        ret = "$(foreach PATCHFILE, $(wildcard " + patch_dir + "/*.patch), patch -p1 -d $(" + var_name("src_dir") + ") < $(PATCHFILE);)" + "\n"
        ret += "$(TOUCH) $(" + var_name("patchall") + ")" + "\n"
        return(ret)

class PatchRule(Rule):
    '''General rule to apply all patches.'''
    def __init__(self, dependencies = "", rule_var_name = None):
        if rule_var_name == None:
            rule_var_name = var_name("patchall")
        Rule.__init__(self, "$(" + var_name("src_dir") + ")/.patched", dependencies, None, rule_var_name)
        self.recipe.append(Patch())

#def patchall(deps):
#    '''Apply all patches to sources in current namespace.
#    
#    @param deps: Additional dependencies are set using this string
#    @type deps: str
#    '''
#    patch_dir = "$(ROOT)/" + namespace.current.replace(".", "/")
#    print var_name("patchall") + " := $(" + var_name("src_dir") + ")/.patched"
#    print "$(" + var_name("patchall") + "): " + deps
#    print "\t$(foreach PATCHFILE, $(wildcard " + patch_dir + "/*.patch), patch -p1 -d $(" + var_name("src_dir") + ") < $(PATCHFILE);)"
#    print "\t$(TOUCH) $(" + var_name("patchall") + ")",
