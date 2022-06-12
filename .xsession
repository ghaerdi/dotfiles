# Network
nm-applet &

# emacs
/usr/bin/emacs --daemon

# Automount Devices
udiskie -t &

# Java Fonts
xsettingsd &

# Volume
volumeicon &

# Clipman
xfce4-clipman &

# Screens
xrandr --output LVDS-1 --auto --output HDMI-1 --auto --left-of LVDS-1
xrandr --output Virtual1 --mode 1920x1080

# Set wallpaper
if [ -f .background.jpg ]; then
    feh --bg-scale .background.jpg
fi

if [ -f .background.png ]; then
    feh --bg-scale .background.png
fi

# Set mouse map
# xmodmap -e "pointer = 3 2 1" &
