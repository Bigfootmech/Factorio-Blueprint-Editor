import os
from shutil import copytree, rmtree
import fnmatch

mods_folder = os.environ.get('USERPROFILE') + '/AppData/Roaming/Factorio/mods/'
source_code_folder = os.environ.get('DEV_ENVIRONMENT') + '/src/main/lua/'
        
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