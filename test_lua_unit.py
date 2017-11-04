import subprocess

def test_lua_unit_tests():
    print("Running tests")
    result = subprocess.run(['lua', '-e', 'package.path = package.path .. ";./src/?.lua;./test/?.lua"', '-l', 'Suite_Test'], 
    shell=True)
    
    amount_of_errors = result.returncode

    print("Errors: " + str(amount_of_errors))
    assert amount_of_errors is 0
    return amount_of_errors