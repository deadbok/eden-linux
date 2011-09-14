'''
Created on 7 Sep 2011

@author: oblivion
'''
def var_name(postfix = None):
    if postfix == None:
        return(local_prefix())
    else:
        return(local_prefix() + postfix.upper())

def package(src_dir, build_dir, version, filename, url):
    print var_name("version") + " := " + version
    print var_name("src_dir") + " := " + src_dir
    if build_dir == "":
        print var_name("build_dir") + " := " + src_dir
    else:
        print var_name("build_dir") + " := " + build_dir
    print var_name("file") + " := " + filename
    print var_name("url") + " := " + url,

def download():
    print "$(DOWNLOAD_DIR)/$(" + var_name("file") + "):"
    print "\t$(WGET) $(" + var_name("url") + ") -P $(DOWNLOAD_DIR)",

def unpack(dir_, filename):
    print filename + ": $(DOWNLOAD_DIR)/$(" + var_name("file") + ")"
    print "ifeq ($(suffix $(" + var_name("file") + ")), .bz2)"
    print "\t$(TAR) -xjf $(DOWNLOAD_DIR)/$(" + var_name("file") + ") -C " + dir_
    print "else ifeq ($(suffix $(" + var_name("file") + ")), .gz)"
    print "\t$(TAR) -xzf $(DOWNLOAD_DIR)/$(" + var_name("file") + ") -C " + dir_
    print "else"
    print "\t$(error Unknown archive format in: $(" + var_name("file") + "))"
    print "endif",
