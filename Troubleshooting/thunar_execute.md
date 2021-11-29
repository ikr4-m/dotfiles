This markdown will telling how to show "Execute" button in Thunar.

# How To
1. Close thunar
```
thunar -q
```
2. Enable execute button
```
xfconf-query --channel thunar --property /misc-exec-shell-scripts-by-default --create --type bool --set true
```
3. Done
