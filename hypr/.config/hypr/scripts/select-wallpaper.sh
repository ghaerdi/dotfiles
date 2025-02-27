ls ~/dotfiles/wallpapers/Wallpapers/ | rofi -dmenu | xargs -I _ sh -c 'swww img -t wipe ~/dotfiles/wallpapers/Wallpapers/_ && sleep 2 && wal -i ~/dotfiles/wallpapers/Wallpapers/_'
