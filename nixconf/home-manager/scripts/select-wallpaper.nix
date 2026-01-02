{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-select-wallpaper" ''
      #!${pkgs.bash}/bin/bash

      # Directory containing wallpapers
      WALLPAPER_DIR="$HOME/dotfiles/wallpapers/Wallpapers/"

      # Check if directory exists
      if [ ! -d "$WALLPAPER_DIR" ]; then
        echo "Error: Wallpaper directory $WALLPAPER_DIR does not exist."
        exit 1
      fi

      # Find all image files in the directory (jpg, jpeg, png)
      WALLPAPER_FILES=$(${pkgs.findutils}/bin/find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \))

      # Supported animation types for transitions
      TRANSITION_TYPES=("simple" "fade" "left" "right" "top" "bottom" "wipe" "grow" "center" "outer" "random" "wave")
      # Select random transition
      RANDOM_TRANSITION=$(${pkgs.coreutils}/bin/printf "%s\n" "''${TRANSITION_TYPES[@]}" | ${pkgs.coreutils}/bin/shuf -n 1)

      # Build rofi list with icons and highlight current wallpaper
      ROFI_MENU=""
      # Get current wallpaper filename
      CURRENT_WALLPAPER_FILE=$(${pkgs.coreutils}/bin/basename "$(${pkgs.swww}/bin/swww query 2>/dev/null | ${pkgs.gawk}/bin/awk '{print $NF}')")

      while IFS= read -r WALLPAPER_PATH; do
        if [[ -z "$WALLPAPER_PATH" ]]; then continue; fi
        WALLPAPER_NAME=$(${pkgs.coreutils}/bin/basename "$WALLPAPER_PATH")
        if [[ "$WALLPAPER_NAME" == "$CURRENT_WALLPAPER_FILE" ]]; then
          ROFI_MENU+="''${WALLPAPER_NAME} (current)\0icon\x1f''${WALLPAPER_PATH}\n"
        else
          ROFI_MENU+="''${WALLPAPER_NAME}\0icon\x1f''${WALLPAPER_PATH}\n"
        fi
      done <<<"$WALLPAPER_FILES"

      # Let user pick a wallpaper through rofi
      SELECTED_WALLPAPER=$(${pkgs.coreutils}/bin/echo -e "$ROFI_MENU" | ${pkgs.rofi}/bin/rofi -dmenu \
        -p "Select Wallpaper" \
        -theme "$HOME/dotfiles/rofi/.config/rofi/wallpaper-selector.rasi" \
        -markup-rows)

      # Remove the "(current)" tag if selected
      SELECTED_WALLPAPER_NAME=$(${pkgs.coreutils}/bin/echo "$SELECTED_WALLPAPER" | ${pkgs.gnused}/bin/sed 's/ (current)//')

      # Apply selected wallpaper with random transition
      if [[ -n "$SELECTED_WALLPAPER_NAME" ]]; then
        FULL_PATH="$WALLPAPER_DIR/$SELECTED_WALLPAPER_NAME"

        ${pkgs.swww}/bin/swww img "$FULL_PATH" \
          --transition-type "$RANDOM_TRANSITION" \
          --transition-duration 1

        # Post-selection hooks (preserved from previous configuration)
        ${pkgs.coreutils}/bin/ln -sf "$FULL_PATH" /tmp/current-wallpaper
        ${pkgs.coreutils}/bin/sleep 1
        ${pkgs.pywal}/bin/wal -i "$FULL_PATH"
        ${pkgs.swaynotificationcenter}/bin/swaync-client -rs

        # Trigger zellij update
        if [ -f "$HOME/.config/zellij/config.kdl" ]; then
          echo '// reload trigger' >> "$HOME/.config/zellij/config.kdl" && ${pkgs.gnused}/bin/sed -i '/^\/\/ reload trigger$/d' "$HOME/.config/zellij/config.kdl"
        fi

        # Trigger quickshell update
        if [ -f "$HOME/dotfiles/quickshell/.config/quickshell/shell.qml" ]; then
          echo '// reload trigger' >> "$HOME/dotfiles/quickshell/.config/quickshell/shell.qml" && ${pkgs.gnused}/bin/sed -i '/^\/\/ reload trigger$/d' "$HOME/dotfiles/quickshell/.config/quickshell/shell.qml"
        fi

        ${pkgs.libnotify}/bin/notify-send -i "$FULL_PATH" -t 3000 -u low -h string:x-canonical-private-synchronous:wallpaper "Wallpaper" "Wallpaper updated and colors generated."
      fi
    '')
  ];
}
