{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-hyprland-window-pop" ''
      #!/bin/bash

      # Toggle to pop-out a tile to stay fixed on a display basis.

      # Usage:
      # nixconf-hyprland-window-pop [width height [x y]]
      #
      # Arguments:
      #   width   Optional. Width of the floating window. Default: 1300
      #   height  Optional. Height of the floating window. Default: 900
      #   x       Optional. X position of the window. Must provide both X and Y to take effect.
      #   y       Optional. Y position of the window. Must provide both X and Y to take effect.
      #
      # Behavior:
      #   - If the window is already pinned, it will be unpinned and removed from the pop layer.
      #   - If the window is not pinned, it will be floated, resized, moved/centered, pinned, brought to top, and popped.

      width=''${1:-1300}
      height=''${2:-900}
      x=''${3:-}
      y=''${4:-}

      active=$(${pkgs.hyprland}/bin/hyprctl activewindow -j)
      pinned=$(echo "$active" | ${pkgs.jq}/bin/jq ".pinned")
      addr=$(echo "$active" | ${pkgs.jq}/bin/jq -r ".address")

      if [[ $pinned == "true" ]]; then
        ${pkgs.hyprland}/bin/hyprctl -q --batch \
          "dispatch pin address:$addr;" \
          "dispatch togglefloating address:$addr;" \
          "dispatch tagwindow -pop address:$addr;"
      elif [[ -n $addr ]]; then
        ${pkgs.hyprland}/bin/hyprctl dispatch togglefloating address:$addr
        ${pkgs.hyprland}/bin/hyprctl dispatch resizeactive exact $width $height address:$addr

        if [[ -n $x && -n $y ]]; then
          ${pkgs.hyprland}/bin/hyprctl dispatch moveactive $x $y address:$addr
        else
          ${pkgs.hyprland}/bin/hyprctl dispatch centerwindow address:$addr
        fi

        ${pkgs.hyprland}/bin/hyprctl -q --batch \
          "dispatch pin address:$addr;" \
          "dispatch alterzorder top address:$addr;" \
          "dispatch tagwindow +pop address:$addr;"
      fi
    '')
  ];
}
