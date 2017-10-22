import subprocess
#subprocess.call('dir')
result = subprocess.check_output(['lua', '-l', 'test.Suite_Test'], shell=True)
print("result")
print(result)