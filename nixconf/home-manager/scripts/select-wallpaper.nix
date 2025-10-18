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
        ${pkgs.coreutils}/bin/ls ~/dotfiles/wallpapers/Wallpapers/ | ${pkgs.rofi}/bin/rofi -dmenu | ${pkgs.findutils}/bin/xargs -I _ ${pkgs.bash}/bin/sh -c '${pkgs.swww}/bin/swww img -t wipe ~/dotfiles/wallpapers/Wallpapers/_ && ${pkgs.coreutils}/bin/sleep 2 && ${pkgs.pywal}/bin/wal -i ~/dotfiles/wallpapers/Wallpapers/_
        ${pkgs.coreutils}/bin/sleep 1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -rs'
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
