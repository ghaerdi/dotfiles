{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "vanzuh-kbd-backlight" ''
      #!/bin/sh

      notification_timeout=1000

      # Path to the backlight brightness file
      BRIGHTNESS_FILE="/sys/class/leds/asus::kbd_backlight/brightness"
      MAX_BRIGHTNESS_FILE="/sys/class/leds/asus::kbd_backlight/max_brightness"

      get_kbd_status() {
        current_brightness=$(cat "$BRIGHTNESS_FILE")
        if [ "$current_brightness" -eq 0 ]; then
          echo "off"
        else
          echo "on"
        fi
      }

      get_kbd_level() {
        current_brightness=$(cat "$BRIGHTNESS_FILE")
        echo "$current_brightness"
      }

      notify_user() {
        current_brightness=$(cat "$BRIGHTNESS_FILE")
        max_brightness=$(cat "$MAX_BRIGHTNESS_FILE")
        percentage=$((current_brightness * 100 / max_brightness))
        ${pkgs.libnotify}/bin/notify-send -t $notification_timeout -u low -h string:x-canonical-private-synchronous:kbd_backlight -h int:value:$percentage "Keyboard Backlight" "Brightness Level: $current_brightness"
      }

      toggle_kbd_backlight() {
        # Get current brightness
        current_brightness=$(cat "$BRIGHTNESS_FILE")

        # Get max brightness
        max_brightness=$(cat "$MAX_BRIGHTNESS_FILE")

        # Calculate next brightness level
        if [ "$current_brightness" -eq "$max_brightness" ]; then
          next_brightness=0
        else
          next_brightness=$((current_brightness + 1))
        fi

        # Set new brightness level
        echo "$next_brightness" > "$BRIGHTNESS_FILE"
      }

      set_kbd_backlight() {
        value=$1
        max_brightness=$(cat "$MAX_BRIGHTNESS_FILE")

        # Validate input
        if [ -z "$value" ] || ! [ "$value" -eq "$value" ] 2>/dev/null; then
          echo "Error: Please provide a valid number (0-$max_brightness)"
          exit 1
        fi

        if [ "$value" -lt 0 ] || [ "$value" -gt "$max_brightness" ]; then
          echo "Error: Value must be between 0 and $max_brightness"
          exit 1
        fi

        # Set brightness level
        echo "$value" > "$BRIGHTNESS_FILE"
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
