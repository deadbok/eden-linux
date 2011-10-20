'''
Unpack templates

@since 14 Oct 2011
@author: oblivion
'''

class Unpack(object):
    '''Class to generate recipes for unpacking files'''
    def __init__(self, filename = "", unpack_dir = "."):
        self.filename = filename
        self.unpack_dir = unpack_dir

    def __str__(self):
        '''Stringify the tar call'''
        ret = "ifeq ($(suffix " + self.filename + "), .bz2)" + '\n'
        ret += "\t$(TAR) -xjf " + self.filename + " -C " + self.unpack_dir + '\n'
        ret += "else ifeq ($(suffix " + self.filename + "), .gz)" + '\n'
        ret += "\t$(TAR) -xzf " + self.filename + " -C " + self.unpack_dir + '\n'
        ret += "else" + '\n'
        ret += "\t$(error Unknown archive format in: " + self.filename + ")" + '\n'
        ret += "endif" + '\n'

        return(ret)


class UnpackRule(Rule):
    '''General rule to unpack sources.'''
    def __init__(self, filename = "", unpack_dir = ".", target = None, rule_var_name = None):
        if target == None:
            target = unpack_dir + "/Makefile"
        if rule_var_name == None:
            rule_var_name = var_name("unpack")
        Rule.__init__(self, target, filename , None , rule_var_name)
        self.recipe.append(Unpack(filename, unpack_dir))
