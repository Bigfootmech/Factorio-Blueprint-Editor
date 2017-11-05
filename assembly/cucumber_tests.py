import os
import subprocess

def launch_lua_cucumber():
    return subprocess.Popen('\ncucumber-lua', shell=True, stdout=subprocess.DEVNULL)

def launch_cucumber():
    return subprocess.run(['cucumber'], shell=True)
    
def run_tests(it_folder, return_from_it_folder):
    os.chdir(it_folder)
    print("Starting cucumber lua server")
    p = launch_lua_cucumber()
    print("Testing")
    result = launch_cucumber()
    print("Stopping cucumber lua server")
    p.kill()
    os.chdir(return_from_it_folder)
    return result