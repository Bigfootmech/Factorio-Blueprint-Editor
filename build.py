import os
import sys
import subprocess
from distutils.dir_util import copy_tree, remove_tree
from distutils.archive_util import make_zipfile
import build_script_helpers.file_generation as generation

version_num = "0.1.2"

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

build_folder = "./target/"
src_folder = "./src/"
docs_folder = "./docs/"
generated_folder = build_folder + "generated/"
composite_mod_folder_name = mod_name + "_" + version_num
release_folder = build_folder + composite_mod_folder_name

def run_tests():
    print("Running tests")
    result = subprocess.run(['lua', '-e', 'package.path = package.path .. ";./src/?.lua;./test/?.lua"', '-l', 'Suite_Test'], 
    shell=True)

    print("Errors: " + str(result.returncode))
    
    return result.returncode
    
def clean():
    print("Cleaning...")
    if os.path.exists(build_folder):
        remove_tree(build_folder)
    
def generate_files():
    print("Generating files")
    generation.generate_basic(generated_folder, main_class)
    generation.generate_keybinds(generated_folder, keybinds_class_location, keybinds_class_name)
    generation.generate_info(generated_folder, info_dump)
    
def assemble_files():
    print("Copying files")
    copy_tree(src_folder, release_folder)
    copy_tree(generated_folder, release_folder)
    copy_tree(docs_folder, release_folder)
    
def zip():
    print("Creating zip")
    os.chdir(build_folder)
    make_zipfile(composite_mod_folder_name, composite_mod_folder_name)
    os.chdir("../")
    
def deploy_to_local():
    generation.deploy_to_local(build_folder, composite_mod_folder_name, mod_name, mod_specific_folder)
    
number_of_failed_tests = run_tests()
if(number_of_failed_tests > 0):
    input("Build failed. Press Enter to exit.")
    sys.exit(number_of_failed_tests) # if fail, exit

clean()
generate_files()
assemble_files()
zip()
deploy_to_local()

input("Press Enter to close.")
sys.exit(0)