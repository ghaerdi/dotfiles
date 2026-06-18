{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-prompt" ''
         #!/bin/sh
      ${lolcat}/bin/lolcat $HOME/dotfiles/nixconf/assets/ascii/nixos-isometric.txt
    '')
  ];
}
