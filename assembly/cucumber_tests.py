import os
import subprocess
import _thread as thread

def launch_lua_cucumber():
    subprocess.run(['cucumber-lua'], shell=True, stdout=subprocess.DEVNULL)

def launch_cucumber():
    subprocess.run(['cucumber'], shell=True)
    
def run_tests(it_folder, return_from_it_folder):
    os.chdir(it_folder)
    t = thread.start_new_thread(launch_lua_cucumber, ())
    result = launch_cucumber()
    os.chdir(return_from_it_folder)