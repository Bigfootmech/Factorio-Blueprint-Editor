#!/usr/bin/env python

import os
import sys
from distutils.dir_util import copy_tree, remove_tree
from distutils.archive_util import make_zipfile
from assembly import file_generation, test_lua_unit

version_deploy = True
local_build = True
    
version_num = "0.2.0"

mod_name = "BPEdit"
mod_specific_folder = "bpedit"

info_dump = {}
info_dump["name"] = mod_name
info_dump["version"] = version_num
info_dump["title"] = "Blueprint Editor"
info_dump["author"] = "Bigfootmech"
info_dump["contact"] = "bigfootmech@gmail.com"
info_dump["homepage"] = "https://forums.factorio.com/viewtopic.php?f=97&t=53634"
info_dump["factorio_version"] = "0.15"
info_dump["dependencies"] = ["base >= 0.15.37"]
info_dump["description"] = "A mod for editing/updating/modifying existing blueprints without placing them in to the world first."

main_class = mod_specific_folder + ".init"
keybinds_class_name = "Keybinds"
keybinds_class_location = mod_specific_folder + ".frontend.keybinds"

src_folder = "./src/main/lua/"
test_folder = "./src/test/lua/"
integration_test_folder = "./src/it/spec/"
build_script_helpers_folder = "./assembly/"
build_folder = "./target/"
docs_folder = "./docs/"
generated_folder = build_folder + "generated/"
composite_mod_folder_name = mod_name + "_" + version_num
release_folder = build_folder + composite_mod_folder_name + "/"

def is_local():
    return os.environ.get('USERPROFILE') != None

def lua_path_format(folder_to_search_in):
    return ";" + folder_to_search_in + "?.lua"

def include_lua_local_folders():
    return 'package.path = package.path .. "' + lua_path_format(src_folder) + lua_path_format(test_folder) + lua_path_format(build_script_helpers_folder) + '"'

def include_lua_it_folders():
    return 'package.path = package.path .. "' + lua_path_format(integration_test_folder) + lua_path_format(release_folder) + '"'

def test_thing(package):
    try:
        number_of_failed_tests = test_lua_unit.test_lua_unit_tests(package)
        if(number_of_failed_tests > 0):
            tests_failed(number_of_failed_tests)
    except AssertionError:
        tests_failed(-1)
    
    
def unit_test():
    print("Running Unit Tests")
    test_thing(include_lua_local_folders())
    
def clean():
    print("Cleaning...")
    if os.path.exists(build_folder):
        remove_tree(build_folder)
    
def generate_files():
    print("Generating files")
    file_generation.generate_basic(generated_folder, main_class)
    file_generation.generate_keybinds(generated_folder, include_lua_local_folders(), keybinds_class_location, keybinds_class_name)
    file_generation.generate_info(generated_folder, info_dump)
    
def assemble_files():
    print("Copying files")
    copy_tree(src_folder, release_folder)
    copy_tree(generated_folder, release_folder)
    copy_tree(docs_folder, release_folder)
    
def install():
    generate_files()
    assemble_files()
    
def integration_test():
    print("Running Integration Tests")
    test_thing(include_lua_it_folders())
    
    
def zip():
    print("Creating zip")
    os.chdir(build_folder)
    make_zipfile(composite_mod_folder_name, composite_mod_folder_name)
    os.chdir("../")
    
def deploy_to_local():
    import assembly.deploy_local as deploy_local
    deploy_local.deploy_to_local(build_folder, composite_mod_folder_name, mod_name, mod_specific_folder)
    
    
def tests_failed(number_of_failed_tests):
    if(local_build):
        input("Build failed. Press Enter to exit.")
    sys.exit(number_of_failed_tests) # if fail, exit
    
def main():

    unit_test()

    clean()
    install()
    
    integration_test()
    
    if(version_deploy):
        zip()
    
    if(local_build):
        deploy_to_local()

    if(local_build):
        input("Press Enter to close.")
    sys.exit(0)
    
main()