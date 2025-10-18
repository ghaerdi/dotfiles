{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "vanzuh-night-mode" ''
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
          ${pkgs.procps}/bin/pkill hyprsunset 2>/dev/null || true
          echo "off" > "$state_file"
        else
          ${pkgs.procps}/bin/pkill hyprsunset 2>/dev/null || true
          ${pkgs.hyprsunset}/bin/hyprsunset -t 3400 >/dev/null 2>&1 &
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