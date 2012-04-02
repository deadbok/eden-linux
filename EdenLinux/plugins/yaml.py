'''
Support for writing YAML files.

@since: 1 Apr 2012
@author: oblivion
'''
import yaml

yaml_filename = mtl_output_dir + "/.config.yaml"
yaml_file = file(yaml_filename, 'w')
yaml_doc = list()

def yaml_save():
    '''
    Save the config variables to a YAML file.
    '''
    for config_var in yaml_doc:
        yaml_file.writelines(config_var)

mtl_plugin_destroy.append(yaml_save)
