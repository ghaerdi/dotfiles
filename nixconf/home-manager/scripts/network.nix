{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-wifi" ''
      #!/bin/sh

      notification_timeout=1000

      get_wifi_status() {
        if [[ $(${pkgs.networkmanager}/bin/nmcli radio wifi) == "enabled" ]]; then
          echo "on"
        else
          echo "off"
        fi
      }

      notify_user() {
        status=$(get_wifi_status)
        if [ "$status" = "on" ]; then
          ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:wifi "WiFi" "WiFi On"
        else
          ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:wifi "WiFi" "WiFi Off"
        fi
      }

      toggle_wifi() {
        if [[ $(${pkgs.networkmanager}/bin/nmcli radio wifi) == "enabled" ]]; then
          ${pkgs.networkmanager}/bin/nmcli radio wifi off
        else
          ${pkgs.networkmanager}/bin/nmcli radio wifi on
        fi
      }

      main() {
        case "$1" in
          status)
            get_wifi_status
            ;;
          toggle)
            toggle_wifi
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
