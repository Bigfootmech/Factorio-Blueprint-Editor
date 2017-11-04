import os
import subprocess
from distutils.dir_util import mkpath, copy_tree, remove_tree
from shutil import copytree, rmtree
import fnmatch
import json

lua_extension = ".lua"

control_class_name = "control"
data_class_name = "data"
keybinds_prototype_class_name = "keybinds"
pretty_print_class_name = "Map"
keybinds_locale_filename = "controls.cfg"
info_filename = "info.json"

prototypes_dirname = "prototypes"
locales_dirname = "locale/en"

keybinds_prototype_class_path = prototypes_dirname + "." + keybinds_prototype_class_name
pretty_print_class_path = "lib.core.types"


keybinds_keystrokes_method = ".get_registered_key_sequences()"
keybinds_locale_method = ".get_locale_text()"

mods_folder = os.environ.get('USERPROFILE') + '/AppData/Roaming/Factorio/mods/'
source_code_folder = os.environ.get('DEV_ENVIRONMENT') + '/src/'

def write_to_file(filename, contents):
    f = open(filename, 'w')
    f.write(contents)
    f.close()

def lua_import_simple(long_class_name):
    return "require('" + long_class_name + "')"

def lua_import_assigned(from_name, class_name):
    return "local " + class_name + " = " + lua_import_simple(from_name + "." + class_name)
    
def lua_add_prototype(prototype):
    return "data:extend(" + prototype + ")"
    
def keybinds_to_prototype(keybinds_class_name):
    return keybinds_class_name + keybinds_keystrokes_method
    
def generate_control(generated_folder, main_class):
    filename = generated_folder + control_class_name + lua_extension
    contents = lua_import_simple(main_class)
    write_to_file(filename, contents)
    
def generate_data(generated_folder):
    filename = generated_folder + data_class_name + lua_extension
    contents = lua_import_simple(keybinds_prototype_class_path)
    write_to_file(filename, contents)
    
def generate_keybinds_prototype(prototypes_dir, keybinds_class_location, keybinds_class_name):
    filename = prototypes_dir + keybinds_prototype_class_name + lua_extension
    contents = ""
    contents = contents + lua_import_assigned(keybinds_class_location, keybinds_class_name) + "\n\n"
    contents = contents + lua_add_prototype(keybinds_to_prototype(keybinds_class_name))
    write_to_file(filename, contents)
    
def generate_locale(locale_dir, lua_path, keybinds_class_location, keybinds_class_name):
    filename = locale_dir + keybinds_locale_filename
    result = subprocess.run(['lua', '-e', lua_path 
    + ';' + lua_import_assigned(keybinds_class_location, keybinds_class_name) 
    + ';' + lua_import_simple("config_file_writer") 
    + '; return write_config_file("' + filename + '",' + keybinds_class_name + keybinds_locale_method + ")" ], 
    shell=True, stdout=subprocess.DEVNULL)


def generate_basic(generated_folder, main_class):
    mkpath(generated_folder)
    generate_control(generated_folder, main_class)
    generate_data(generated_folder)
    
def generate_keybinds(generated_folder, lua_path, keybinds_class_location, keybinds_class_name):
    prototypes_dir = generated_folder + prototypes_dirname + "/"
    mkpath(prototypes_dir)
    generate_keybinds_prototype(prototypes_dir, keybinds_class_location, keybinds_class_name)
    locale_dir = generated_folder + locales_dirname + "/"
    mkpath(locale_dir)
    generate_locale(locale_dir, lua_path, keybinds_class_location, keybinds_class_name)
    
def generate_info(generated_folder, info_dump):
    mkpath(generated_folder)
    info_path = generated_folder + info_filename
    with open(info_path, 'w') as f:
        json.dump(info_dump, f)
        
def safe_remove(foldername):
    if os.path.exists(foldername):
        rmtree(foldername)
    
def clear_mod_folder(mod_name, mod_specific_src_folder):
    for file in os.listdir(mods_folder):
        if fnmatch.fnmatch(file, mod_name + '*'):
            abspath = mods_folder + file
            print("Clearing " + str(file))
            if(os.path.isdir(abspath)):
                safe_remove(abspath)
            else:
                os.remove(abspath)
            
def remove_modpart_and_symlink_to_source_code(mod_and_version, subbing_folder):
    mod_folder_full = mods_folder + mod_and_version + "/"
    safe_remove(mod_folder_full + subbing_folder)
    os.symlink(source_code_folder + subbing_folder, mod_folder_full + subbing_folder)

def deploy_to_local(build_folder, composite_mod_folder_name, mod_name, mod_specific_src_folder):
    clear_mod_folder(mod_name, mod_specific_src_folder)
    copytree(build_folder + composite_mod_folder_name, mods_folder + composite_mod_folder_name)
    remove_modpart_and_symlink_to_source_code(composite_mod_folder_name, mod_specific_src_folder)
    remove_modpart_and_symlink_to_source_code(composite_mod_folder_name, "lib")