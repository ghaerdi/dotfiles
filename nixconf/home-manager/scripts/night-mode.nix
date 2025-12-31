{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-night-mode" ''
      #!/bin/sh

      notification_timeout=1000
      state_file="/tmp/night-mode-state"

      get_night_mode_status() {
        if [ -f "$state_file" ] && [ "$(cat "$state_file")" = "on" ]; then
          echo "on"
        else
          echo "off"
        fi
      }

      notify_user() {
        status=$(get_night_mode_status)
        if [ "$status" = "on" ]; then
          ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:night-mode "Night Mode" "Night Mode On"
        else
          ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:night-mode "Night Mode" "Night Mode Off"
        fi
      }

      toggle_night_mode() {
        if [ "$(get_night_mode_status)" = "on" ]; then
          ${pkgs.hyprland}/bin/hyprctl hyprsunset identity
          echo "off" > "$state_file"
        else
          ${pkgs.hyprland}/bin/hyprctl hyprsunset temperature 4000
          ${pkgs.hyprland}/bin/hyprctl hyprsunset gamma 85
          echo "on" > "$state_file"
        fi
      }

      main() {
        case "$1" in
          status)
            get_night_mode_status
            ;;
          toggle)
            toggle_night_mode
            if [ "$2" = "--notify" ]; then
              notify_user
            fi
            ;;
          *)
            echo "Usage: $0 {status|toggle [--notify]}"
            exit 1
            ;;
        esac
      }

      main "$@"
    '')
  ];
}
