{
  config,
  pkgs,
  homeDirectory,
  ...
}: {
  home.packages = with pkgs; [
    brightnessctl
    (pkgs.writeShellScriptBin "nixconf-asus-proart-kbd-backlight" ''
      #!/bin/sh

      notification_timeout=1000
      DEVICE="asus::kbd_backlight"

      # Helper function to run brightnessctl for the keyboard
      bctl() {
        ${pkgs.brightnessctl}/bin/brightnessctl -d "$DEVICE" "$@"
      }

      get_kbd_status() {
        current_brightness=$(bctl get)
        if [ "$current_brightness" -eq 0 ]; then
          echo "off"
        else
          echo "on"
        fi
      }

      get_kbd_level() {
        bctl get
      }

      get_icon() {
        brightness=$1
        if [ "$brightness" -eq 0 ]; then
          echo "${homeDirectory}/dotfiles/nixconf/assets/icons/keyboard-off.svg"
        else
          echo "${homeDirectory}/dotfiles/nixconf/assets/icons/keyboard.svg"
        fi
      }

      notify_user() {
        current_brightness=$(bctl get)
        max_brightness=$(bctl max)
        percentage=$((current_brightness * 100 / max_brightness))
        icon=$(get_icon $current_brightness)
        ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -i "$icon" -h string:x-canonical-private-synchronous:kbd_backlight -h int:value:$percentage "Keyboard Backlight" "Brightness Level: $current_brightness"
      }

      toggle_kbd_backlight() {
        current_brightness=$(bctl get)
        max_brightness=$(bctl max)

        # Calculate next brightness level (cycle: 0 -> 1 -> ... -> max -> 0)
        if [ "$current_brightness" -eq "$max_brightness" ]; then
          next_brightness=0
        else
          next_brightness=$((current_brightness + 1))
        fi

        bctl set "$next_brightness" > /dev/null
      }

      set_kbd_backlight() {
        value=$1
        # brightnessctl handles validation limits automatically
        bctl set "$value" > /dev/null
      }

      main() {
        case "$1" in
          status)
            get_kbd_status
            ;;
          get)
            get_kbd_level
            ;;
          set)
            set_kbd_backlight "$2"
            if [ "$3" = "--notify" ]; then
              notify_user
            fi
            ;;
          toggle)
            toggle_kbd_backlight
            if [ "$2" = "--notify" ]; then
              notify_user
            fi
            ;;
          *)
            echo "Usage: $0 {status|get|set <value>|toggle} [--notify]"
            exit 1
            ;;
        esac
      }

      main "$@"
    '')
  ];
}
