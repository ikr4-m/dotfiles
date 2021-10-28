# Install Theme, Font, and Icons
1. Move your theme folder to `~/.themes` or `/usr/share/themes`.
2. Move your icon folder to `~/.icons` or `/usr/share/icons`.
3. Move your font to `~/.fonts` or `/usr/share/fonts` and do `fc-cache -vf`.
4. Go to `~/.config/gtk-3-0` and change with this:
```
[Settings]
gtk-icon-theme-name = IconNameHere
gtk-theme-name = ThemeNameHere
gtk-font-name = DefaultGTKFontHere
```

# Uninstall
1. Just change the theme name with the new one.
2. Delete the folder.
