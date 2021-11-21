import subprocess

def get_monitor_length():
    output = subprocess.run(['xrandr'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    output = output.split("\n")
    output = [o for o in output if "connected" in o]
    return len(output)

for i in range(0, get_monitor_length()):
    print(i)
