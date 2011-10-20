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
        ret = '$(WGET) ' + self.url + ' -P ' + self.download_dir + '\n'
        return(ret)

class DownloadRule(Rule):
    '''
    General rule to download sources.
    
    Uses: $(DOWNLOAD_DIR)'''
    def __init__(self, url = "http://localhost", rule_var_name = None):
        if rule_var_name == None:
            rule_var_name = var_name("download")
        Rule.__init__(self, "$(DOWNLOAD_DIR)" + "/$(notdir " + url + ")", '' , None , rule_var_name)
        self.recipe.append(Download("$(DOWNLOAD_DIR)", url))
