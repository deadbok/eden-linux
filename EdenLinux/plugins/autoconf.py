'''
Created on 7 Sep 2011

@author: oblivion
'''
def autoconf(env, param, deps):
    print var_name("config") + " = $(" + var_name("build_dir") + ")/Makefile"
    print "$(" + var_name("config") + "): " + "$(" + var_name("src_dir") + ")/configure " + deps
    print "\t($(MKDIR) " + "$(" + var_name("build_dir") + "); \\"
    print "\tcd " + "$(" + var_name("build_dir") + "); \\"
    print "\t" + env + " " + "$(" + var_name("src_dir") + ")/configure \\"
    print "\t" + param + " \\"
    print "\t);",
