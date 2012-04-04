'''
Support for writing YAML files.

@since: 1 Apr 2012
@author: oblivion
'''
import yaml

yaml_filename = mtl.output_dir + "/.config.yaml"
yaml_file = open(yaml_filename, 'w')
yaml_doc = list()

def yaml_save():
    '''
    Save the config variables to a YAML file.
    '''
    for config_var in yaml_doc:
        yaml_file.writelines(config_var)
    yaml_file.close()

mtl_plugin = plugin.Plugin("yaml", yaml_save)

