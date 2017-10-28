import subprocess

def generate_files():
    print("Generating files")

def run_tests():
    print("Running tests")
    result = subprocess.run(['lua', '-l', 'test.Suite_Test'], shell=True)

    print("Errors: " + str(result.returncode))
    
    return result.returncode
    
def copy_files():
    print("Copying files")
    

def zip():
    print("Creating zip")
    
run_tests()


input("Press Enter to close.")