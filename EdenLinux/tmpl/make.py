'''
Created on 7 Sep 2011

@author: oblivion
'''
def make(env, param, target_name, target_file, dep):
    print var_name(target_name) + " = ",
    if isinstance(target_file, str):
        print target_file
    else:
        print var_name(target_name).lower()
    print "$(" + var_name(target_name) + "): " + dep
    print "\t",
    if len(env) > 0:
        print env + " ",
    print "$(MAKE) " + param + " -C $(" + var_name("build_dir") + ") " + target_name,
#$(" + var_name("build_dir") + ")/Makefile "
