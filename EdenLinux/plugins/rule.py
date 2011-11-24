'''
Stuff for generic make file rules

@since: 28 Sep 2011
@author: oblivion
'''
class Rule(object):
    '''
    Basic make rule container.
    '''
    def __init__(self, target = "", dependencies = "", recipe = None, rule_var_name = ""):
        '''
        Constructor.
        '''
        self.target = target
        self.dependencies = dependencies
        if (recipe == None) or (recipe == ""):
            self.recipe = list()
            if rule_var_name == "":
                self.recipe.append("@echo -en $(TITLEBAR_START)" + target + "$(TITLEBAR_END)\n")
                self.recipe.append("@echo -e --+ $(GREEN_COLOR)" + target + "$(NO_COLOR) +--\n")
            else:
                self.recipe.append("@echo -en $(TITLEBAR_START)" + rule_var_name + "$(TITLEBAR_END)\n")
                self.recipe.append("@echo -e --+ $(GREEN_COLOR)" + rule_var_name + "$(NO_COLOR) +--\n")
        else:
            self.recipe = recipe
        self.rule_var = rule_var_name


    def __str__(self):
        '''
        Return a string usable as a rule in a make file
        
        @rtype: str
        @return: The rule
        '''
        #Create a variable referencing the rule, if a name is given
        if len(self.rule_var) == 0:
            #No variable
            ret = self.target + ": " + self.dependencies + "\n"
        else:
            #Create a variable
            ret = self.rule_var + " := " + self.target + "\n"
            ret += "$(" + self.rule_var + ")" + ": " + self.dependencies + "\n"
        for part in self.recipe:
            found = False
            for line in str(part).splitlines(True):
                conditionals = ['ifeq', 'ifneq', 'ifdef', 'idndef', 'else', 'endif' ]
                for keyword in conditionals:
                    if line.startswith(keyword):
                        found = True
                        break
                if found:
                    ret += line
                    if line.startswith('endif'):
                            found = False
                else:
                    ret += "\t" + line
        ret += "\n"
        return(ret)
