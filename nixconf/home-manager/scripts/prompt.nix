{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-prompt" ''
         #!/bin/sh
      cat $HOME/dotfiles/nixconf/assets/ascii/nixos-isometric.txt
    '')
  ];
}
