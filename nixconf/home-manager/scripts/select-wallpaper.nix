# ls ~/dotfiles/wallpapers/Wallpapers/ | rofi -dmenu | xargs -I _ sh -c 'swww img -t wipe ~/dotfiles/wallpapers/Wallpapers/_ && sleep 2 && wal -i ~/dotfiles/wallpapers/Wallpapers/_'
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "vanzuh-wallpaper" ''
      #!/bin/sh

      notification_timeout=3000

      notify_user() {
        ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:wallpaper "Wallpaper" "Colors generated."
      }

      select_wallpaper() {
        ls ~/dotfiles/wallpapers/Wallpapers/ | rofi -dmenu | xargs -I _ sh -c 'swww img -t wipe ~/dotfiles/wallpapers/Wallpapers/_ && sleep 2 && wal -i ~/dotfiles/wallpapers/Wallpapers/_
        sleep 1 && swaync-client -rs'
      }

      main() {
        case "$1" in
          select)
            select_wallpaper
            if [ "$2" = "--notify" ]; then
              notify_user
            fi
            ;;
          *)
            echo "Usage: $0 {select [--notify]}"
            exit 1
            ;;
        esac
      }

      main "$@"
    '')
  ];
}
