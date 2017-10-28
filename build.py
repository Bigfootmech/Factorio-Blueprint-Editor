import subprocess
import os
import sys
from distutils.dir_util import copy_tree, remove_tree
from distutils.archive_util import make_zipfile

mod_name = "BPEdit"
version_num = "0.1.1"
composite_mod_folder_name = mod_name + "_" + version_num
build_folder = "./target/"
src_folder = "./src/"
docs_folder = "./docs/"
generated_subfolder = "generated/"
generated_folder = build_folder + generated_subfolder
release_folder = build_folder + composite_mod_folder_name

def run_tests():
    print("Running tests")
    result = subprocess.run(['lua', '-e', 'package.path = package.path .. ";./src/?.lua;./test/?.lua"', '-l', 'Suite_Test'], shell=True)

    print("Errors: " + str(result.returncode))
    
    return result.returncode
    
def clean():
    print("Cleaning...")
    if os.path.exists(build_folder):
        remove_tree(build_folder)
    
def generate_files():
    print("Generating files")
    
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
    
number_of_failed_tests = run_tests()
if(number_of_failed_tests > 0):
    input("Build failed. Press Enter to exit.")
    sys.exit(number_of_failed_tests)
# if fail, exit
clean()
generate_files()
assemble_files()
zip()

input("Press Enter to close.")
sys.exit(0)