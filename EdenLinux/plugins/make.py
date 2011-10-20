'''
Handling of things to do with calling make

@since: 7 Sep 2011
@author: oblivion
'''

class Make(object):
    '''Class to generate recipes for calling make'''
    def __init__(self, env = "", param = "", build_dir = ".", make_target = "all"):
        self.env = env
        self.param = param
        self.build_dir = build_dir
        self.make_target = make_target

    def __str__(self):
        '''Stringify the make call'''
        if len(self.env) == 0:
            ret = "$(MAKE) "
        else:
            ret = self.env + " $(MAKE) "
        ret += self.param + " -C " + self.build_dir + " " + self.make_target + "\n"
        return(ret)

class MakeRule(Rule):
    '''General rule to run make.'''
    def __init__(self, env = "", param = "", build_dir = ".", make_target = "all", target = "", dependencies = "", rule_var_name = ""):
        Rule.__init__(self, target, dependencies, None, rule_var_name)
        self.recipe.append(Make(env, param, build_dir, make_target))

#def make(env, param, target_name, target_file, dep):
#    print var_name(target_name) + " = ",
#    if isinstance(target_file, str):
#        print target_file
#    else:
#        print var_name(target_name).lower()
#    print "$(" + var_name(target_name) + "): " + dep
#    print "\t",
#    if len(env) > 0:
#        print env + " ",
#    print "$(MAKE) " + param + " -C $(" + var_name("build_dir") + ") " + target_name,
#$(" + var_name("build_dir") + ")/Makefile "
