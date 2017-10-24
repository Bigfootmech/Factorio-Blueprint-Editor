import subprocess

result = subprocess.run(['lua', '-l', 'test.Suite_Test'], shell=True)

print("Errors: " + str(result.returncode))

input("Press Enter to close.")