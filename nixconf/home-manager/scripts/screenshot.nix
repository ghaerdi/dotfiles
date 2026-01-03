{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-screenshot" ''
      #!/bin/bash

      [[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
      OUTPUT_DIR="$HOME/Pictures/screenshots"

      if [[ ! -d "$OUTPUT_DIR" ]]; then
      	${pkgs.coreutils}/bin/mkdir -p "$OUTPUT_DIR"
      fi

      ${pkgs.hyprshot}/bin/hyprshot -m ''${1:-region} --freeze --raw |
      	${pkgs.satty}/bin/satty --filename - \
      		--output-filename "$OUTPUT_DIR/screenshot-$(${pkgs.coreutils}/bin/date +'%Y-%m-%d_%H-%M-%S').png" \
      		--early-exit \
      		--actions-on-enter save-to-clipboard \
      		--save-after-copy \
      		--copy-command '${pkgs.wl-clipboard}/bin/wl-copy'
    '')
  ];
}
