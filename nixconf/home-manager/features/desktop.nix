{
  pkgs,
  config,
  lib,
  zen-browser,
  ...
}: {
  programs.home-manager.enable = true;
  programs.brave = {
    enable = true;
    extensions = [
      {id = "hdokiejnpimakedhajhdlcegeplioahd";}
    ];
  };

  home.packages = with pkgs; [
    # GUI
    telegram-desktop
    youtube-music
    pavucontrol
    zen-browser
    obs-studio
    obsidian
    # stremio
    vesktop
    dunst

    # TOOLS
    ghostty
    brightnessctl
    pulseaudio
    redshift
    blueman
    xcolor
    volctl
    picom
    feh

    # PROGRAMMING & DEPENDENCIES
    haskellPackages.greenclip
    xorg.xmodmap

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-emoji
    noto-fonts

    (pkgs.writeShellScriptBin "toggle-polybar" ''
         if [ "$(ps -a | grep polybar | awk '{print $4}' | head -n 1)" = "polybar" ]; then
      ${pkgs.dunst}/bin/dunstify -t 1500 -u low "Closing polybar. Wait..."
           ${pkgs.polybar}/bin/polybar-msg cmd quit
         else
           ${pkgs.polybar}/bin/polybar -r laptop &
         fi
    '')
  ];

  fonts.fontconfig = {
    enable = true;
  };

  nixpkgs.config.pulseaudio = true;

  services = {
    syncthing.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "neovim";
  };
}
