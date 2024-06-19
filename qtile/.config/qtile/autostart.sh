#!/bin/sh

~/.config/polybar/launch.py &
picom -b &
greenclip daemon &
nm-applet &
dunst & -config ~/.config/dunst/dunstrc &
xmodmap -e 'pointer = 3 2 1' &
feh --bg-fill ~/.dotfiles/Wallpapers/pixel-art-wallpaper-20072220050556.png
