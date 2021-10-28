# Parsing CPU Usage
# Dependency: mpstat(sysstat)
from subprocess import run, PIPE
from sys import argv
from math import floor

flag = argv.pop()
get_mpstat = run('mpstat', stdout=PIPE).stdout
get_mpstat = 100 - float(str(get_mpstat).split(' ').pop().rstrip('\\n\''))

print(floor(get_mpstat) if flag == '--decimal' else get_mpstat)
