import os
from os import path

path_to_mode = path.join(path.expanduser("~"), "/home/munn/.config/eww/scripts/Mode")
files = os.listdir(path_to_mode)

parse_files = []
for file in files:
    group_file = []
    group_file.append(file.split('.')[0])

    file = file.replace(' ', "\ ")
    file = path.join(path_to_mode, file)
    file = f"eww close launcher && /bin/sh -c \\\"{file}\\\""
    group_file.append(file)
    parse_files.append(group_file)

eww_button = map(lambda x: "(button :class \"item\" :onclick \"{ex}\" \"{nm}\")".format(ex=x[1],nm=x[0]), parse_files)
eww_button = " ".join(eww_button)
eww_box= f"(box :orientation \"v\" :spacing 5 :class \"apps\" :halign \"center\" :valign \"center\" {eww_button})"

print(eww_box)