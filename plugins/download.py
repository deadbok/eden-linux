'''
Download templates

@since 14 Oct 2011
@author: oblivion
'''

class Download(object):
    '''Class to generate recipes for downloading files'''
    def __init__(self, download_dir = ".", url = "http://localhost"):
        self.download_dir = download_dir
        self.url = url

    def __str__(self):
        '''Stringify the wget call'''
        ret = "ifeq ($(findstring https://, " + self.url + "), https://)" + '\n'
        ret += '\t$(WGET) ' + self.url + ' -P ' + self.download_dir + '\n'        
        ret += "else ifeq ($(findstring http://, " + self.url + "), http://)" + '\n'
        ret += '\t$(WGET) ' + self.url + ' -P ' + self.download_dir + '\n'
        ret += "else ifeq ($(findstring ftp://, " + self.url + "), ftp://)" + '\n'
        ret += '\t$(WGET) ' + self.url + ' -P ' + self.download_dir + '\n'
        ret += "else ifeq ($(findstring git://, " + self.url + "), git://)" + '\n'
        ret += '\t$(GIT-CLONE) ' + self.url + self.download_dir + '\n'
        ret += "endif" + '\n'
        return(ret)

class DownloadRule(Rule):
    '''
    General rule to download sources.
    
    Uses: $(DOWNLOAD_DIR)
    '''
    def __init__(self, url = "http://localhost", dl_dir = "$(DOWNLOAD_DIR)", rule_var_name = None):
        if rule_var_name == None:
            rule_var_name = var_name("download")
        Rule.__init__(self, dl_dir + "/$(notdir " + url + ")", '' , None , rule_var_name)
        self.recipe.append(Download(dl_dir, url))
