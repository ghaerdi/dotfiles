# Composer
picom &

# Network
nm-applet &

# Keyboard Layout
setxkbmap es &

# Automount Devices
udiskie -t &

# Java Fonts
xsettingsd &

# Volume
volumeicon &

# Clipman
xfce4-clipman &

# Screens
xrandr --output LVDS1 --auto --output HDMI1 --auto --left-of LVDS1

# Set wallpaper
if [ -f .background.jpg ]; then
    feh --bg-scale .background.jpg
fi

if [ -f .background.png ]; then
    feh --bg-scale .background.png
fi

# Set keyboard map
setxkbmap us intl &
# setxkbmap de deadtilde &

# Set mouse map
xmodmap -e "pointer = 3 2 1" &
