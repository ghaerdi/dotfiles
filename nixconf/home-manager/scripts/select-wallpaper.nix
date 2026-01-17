{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    waypaper
    (pkgs.writeShellScriptBin "nixconf-select-wallpaper" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.waypaper}/bin/waypaper
    '')
    (pkgs.writeShellScriptBin "nixconf-generate-colors" ''
      #!${pkgs.bash}/bin/bash

      NOTIFY=false
      WALLPAPER_PATH=""

      for arg in "$@"; do
        case $arg in
          --notify)
            NOTIFY=true
            ;;
          *)
            WALLPAPER_PATH="$arg"
            ;;
        esac
      done

      FULL_PATH="$WALLPAPER_PATH"

      if [[ -z "$FULL_PATH" ]]; then
        echo "Error: No wallpaper path provided." >&2
        exit 1
      fi

      # Post-selection hooks
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

      if [ "$NOTIFY" = true ]; then
        ${pkgs.libnotify}/bin/notify-send -i "$FULL_PATH" -t 3000 -u low -h string:x-canonical-private-synchronous:wallpaper "Wallpaper" "Wallpaper updated and colors generated."
      fi
    '')
  ];
}
