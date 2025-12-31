{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-bluetooth" ''
      #!/bin/sh

      notification_timeout=1000

      get_bluetooth_status() {
        if [[ $(${pkgs.bluez}/bin/bluetoothctl show | grep "Powered: yes") ]]; then
          echo "on"
        else
          echo "off"
        fi
      }

      notify_user() {
        status=$(get_bluetooth_status)
        if [ "$status" = "on" ]; then
          ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:bluetooth "Bluetooth" "Bluetooth On"
        else
          ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:bluetooth "Bluetooth" "Bluetooth Off"
        fi
      }

      toggle_bluetooth() {
        if [[ $(${pkgs.bluez}/bin/bluetoothctl show | grep "Powered: yes") ]]; then
          ${pkgs.bluez}/bin/bluetoothctl power off
        else
          ${pkgs.bluez}/bin/bluetoothctl power on
        fi
      }

      main() {
        case "$1" in
          status)
            get_bluetooth_status
            ;;
          toggle)
            toggle_bluetooth
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
