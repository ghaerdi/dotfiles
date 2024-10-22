#!/bin/bash

if [ "$1" == "light" ] || [ "$1" == "dark" ]; then
    THEME="Gruvbox-${1^}"  # Capitalize the first letter of the argument
    
    # Check and create directories if they don't exist
    for version in 2.0 3.0 4.0; do
        # [ ! -d ~/.config/gtk-$version ] && mkdir -p ~/.config/gtk-$version
        ln -sf ~/.themes/$THEME/gtk-$version ~/.config
    done
else
    echo "Invalid argument. Use 'light' or 'dark'."
fi
