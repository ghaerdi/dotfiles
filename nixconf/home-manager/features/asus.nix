{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "kbd-backlight-toggle" ''
      #!/bin/sh

      # Path to the backlight brightness file
      BRIGHTNESS_FILE="/sys/class/leds/asus::kbd_backlight/brightness"
      MAX_BRIGHTNESS_FILE="/sys/class/leds/asus::kbd_backlight/max_brightness"

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
      echo "$next_brightness" | sudo tee "$BRIGHTNESS_FILE" > /dev/null

      # Provide visual feedback
      if command -v notify-send >/dev/null 2>&1; then
        notify-send "Keyboard Backlight" "Brightness set to: $next_brightness"
      fi

      exit 0
    '')
  ];
}
