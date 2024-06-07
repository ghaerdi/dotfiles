#!/bin/sh

~/.config/polybar/launch.sh &
picom -b &
xfce4-clipman &
nm-applet &
dunst & -config ~/.config/dunst/dunstrc &
xmodmap -e 'pointer = 3 2 1'
