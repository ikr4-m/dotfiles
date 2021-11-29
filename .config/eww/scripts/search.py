import subprocess
import sys
from pathlib import Path

def get_query_desktop(query, limit=8):
    def exec_shell(args):
        egrep = subprocess.run(args, stdout=subprocess.PIPE).stdout.decode("utf-8").split("\n")
        egrep.pop()
        return list(egrep)

    def map_desktop(s):
        s = s.split(":")
        return [s[1][5:], "eww close mainmenu && gtk-launch {app}".format(app=s[0])]

    def map_bin(s):
        return ["Execute '{app}'".format(app=s), "eww close mainmenu && {app} &".format(app=s)]

    app = []

    # Get .desktop based from name search
    args = [
        "/bin/sh", "-c",
        "cd /usr/share/applications && egrep -ir \"^Name=.*{q}\" *.desktop".format(q=query)
    ]
    app += map(map_desktop, exec_shell(args))

    # Get from /usr/bin
    args[2] = "cd /usr/bin && ls | egrep -i \"{q}\"".format(q=query)
    app += map(map_bin, exec_shell(args))

    #return app
    return app[0:limit]

def formatting_eww(desktop):
    desktop = map(lambda x: "(button :class \"item\" :onclick \"{ex}\" \"{nm}\")".format(ex=x[1],nm=x[0]), desktop)
    desktop = " ".join(desktop)
    ctx = "(box :orientation \"v\" :spacing 5 :class \"apps\" :halign \"center\" :valign \"center\" {buf})"
    return ctx.format(buf=desktop)

# Initialize Query
query = get_query_desktop(sys.argv.pop())
formatted = formatting_eww(query)

# Echo search result
with open(str(Path.home()) + "/dotfiles/.config/eww/scripts/search_items.txt", "w") as fin:
    fin.writelines([formatted])
    fin.close()
