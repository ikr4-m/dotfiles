import subprocess
import math

def get_int_subp(args):
    return int(subprocess.run(args, stdout=subprocess.PIPE).stdout)

current = get_int_subp(['brightnessctl', 'g'])
maxim = get_int_subp(['brightnessctl', 'm'])
print(math.floor(current / maxim * 100))
