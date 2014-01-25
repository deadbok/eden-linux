'''
Autoconf related stuff.

@since: 7 Sep 2011
@author: oblivion
'''
class Autoconf(object):
    '''Class to generate recipes for calling autoconf'''
    def __init__(self, env = "", param = "", src_dir = ".", build_dir = "."):
        self.env = env
        self.param = param
        self.build_dir = build_dir
        self.src_dir = src_dir

    def __str__(self):
        '''Stringify the autoconf call'''
        ret = '($(MKDIR) ' + self.build_dir + '; \\\n'
        ret += "$(CD) " + self.build_dir + ";\\\n"
        ret += self.env + " " + self.src_dir + "/configure " + self.param + ';\\\n'
        ret += '); \n'
        return(ret)

class AutoconfRule(Rule):
    '''General autoconf configure rule.'''
    def __init__(self, env = "", param = "", src_dir = ".", build_dir = ".", 
                 target = "", dependencies = "", rule_var_name = None):
        if rule_var_name == None:
            rule_var_name = var_name("config")
        Rule.__init__(self, target, dependencies, None, rule_var_name)
        self.recipe.append(Autoconf(env, param, src_dir, build_dir))

#def autoconf(env, param, deps):
#    print var_name("config") + " = $(" + var_name("build_dir") + ")/Makefile"
#    print "$(" + var_name("config") + "): " + "$(" + var_name("src_dir") + ")/configure " + deps
#    print "\t($(MKDIR) " + "$(" + var_name("build_dir") + "); \\"
#    print "\tcd " + "$(" + var_name("build_dir") + "); \\"
#    print "\t" + env + " " + "$(" + var_name("src_dir") + ")/configure \\"
#    print "\t" + param + " \\"
#    print "\t);",

class AutoconfPackage(Package):
    '''
    Class for automating the whole process of an autoconf package.
    
    Uses: $(DOWNLOAD_DIR)
    Uses: $(${local()}CONFIG_PARAM)
    Uses: $(${local()}BUILD_ENV)
    Uses: $(${local()}INSTALL_ENV)
    Uses: $(${local()}CONFIG_PARAM)
    Uses: $(${local()}BUILD_PARAM)
    Uses: $(${local()}INSTALL_PARAM)
    USes: $(${local()}DEPENDENCIES)
    '''
    def __init__(self, src_dir = ".", build_dir = "", version = "0.0",
                 url = "http://localhost", target = ".", env = ""):
        Package.__init__(self, src_dir, build_dir, version, url, target)

        #Download rule
#        download = Rule("$(DOWNLOAD_DIR)/$(" + var_name("file") + ")", rule_var_name = var_name("download"))
#        download.recipe.append(Download("$(DOWNLOAD_DIR)", "$(" + var_name("url") + ")"))
        download = DownloadRule(var_name("url", True))
        self.rules['download'] = download

        #Unpack rule
        unpack = Rule(var_name("src_dir", True) + "/README", 
                      "$(DOWNLOAD_DIR)/" + var_name("file", True), 
                      rule_var_name = var_name("unpack"))
        unpack.recipe.append(Unpack("$(DOWNLOAD_DIR)/" + var_name("file", True), 
                                    "$(abspath " + var_name("src_dir", True) + "/../)"))
        self.rules['unpack'] = unpack

        #Patch rule
        patch = PatchRule(var_name("unpack", True))
        self.rules['patchall'] = patch

        #Autoconf
        autoconf = Rule(var_name("build_dir", True) + "/Makefile", 
                        var_name("patchall", True) + " $(" + local() + "DEPENDENCIES)", 
                        rule_var_name = var_name("config"))
        autoconf.recipe.append(Autoconf("$(" + local() + "CONFIG_ENV)", 
                                        "$(" + local() + "CONFIG_PARAM)", 
                                        var_name("src_dir", True), 
                                        var_name("build_dir", True)))
        self.rules['config'] = autoconf

        #Build
        build = Rule(var_name("build_dir", True) + "/.build", 
                     var_name("config", True), 
                     rule_var_name = var_name("build"))
        build.recipe.append(Make("$(" + local() + "BUILD_ENV)", 
                                 "$(" + local() + "BUILD_PARAM)", 
                                 var_name("build_dir", True), "all"))
        build.recipe.append("$(TOUCH) " + var_name("build_dir", True) + "/.build\n")
        self.rules['build'] = build

        #Install
        install = Rule(target, var_name("build", True), 
                       rule_var_name = var_name("install"))
        install.recipe.append(Make("$(" + local() + "INSTALL_ENV)", 
                                   "$(" + local() + "INSTALL_PARAM)", 
                                   var_name("build_dir", True), "install"))
        self.rules['install'] = install
