import subprocess

def test_lua_unit_tests(package_path_addition):
    print("Running tests")
    result = subprocess.run(['lua', '-e', package_path_addition, '-l', 'Suite_Test'], 
    shell=True)
    
    amount_of_errors = result.returncode

    print("Errors: " + str(amount_of_errors))
    assert amount_of_errors is 0
    return amount_of_errors