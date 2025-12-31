{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-hyprland-window-pop" ''
      #!/bin/bash

      # Toggle to pop-out a tile to stay fixed on a display basis.

      active=$(${pkgs.hyprland}/bin/hyprctl activewindow -j)
      pinned=$(echo "$active" | ${pkgs.jq}/bin/jq .pinned)
      addr=$(echo "$active" | ${pkgs.jq}/bin/jq -r  ".address")
      [ -z "$addr" ] && { echo "No active window"; exit 0; }

      if [ "$pinned" = "true" ]; then
        ${pkgs.hyprland}/bin/hyprctl -q --batch \
        "dispatch pin address:$addr;" \
        "dispatch togglefloating address:$addr;" \
        "dispatch tagwindow -pop address:$addr;"
      else
        ${pkgs.hyprland}/bin/hyprctl -q --batch \
        "dispatch togglefloating address:$addr;" \
        "dispatch centerwindow address:$addr;" \
        "dispatch pin address:$addr;" \
        "dispatch alterzorder top address:$addr;" \
        "dispatch tagwindow +pop address:$addr;"
      fi
    '')
  ];
}
