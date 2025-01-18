#!/bin/sh

polybar -r laptop &
picom -b &
volctl &
greenclip daemon &
nm-applet &
blueman-applet &
dunst -config ~/.config/dunst/dunstrc &
xmodmap -e 'pointer = 3 2 1' &
xinput set-button-map "ASUF1204:00 2808:0104 Touchpad" 3 2 1 4 5 6 7 &
xinput set-button-map "ASCP1A01:00 093A:3014 Touchpad" 3 2 1 4 5 6 7 &
feh --bg-fill ~/dotfiles/wallpapers/Wallpapers/pixel-art-wallpaper-20072220050556.png
