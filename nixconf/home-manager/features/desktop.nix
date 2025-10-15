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
    veracrypt
    gnome-calculator
    gnome-disk-utility
    nautilus # file explorer
    baobab # disk usage
    eog # gnome image viewer
    evince # gnome document viewer
    localsend
    telegram-desktop
    youtube-music
    pavucontrol
    zen-browser
    obs-studio
    obsidian
    vesktop
    ghostty
    blueberry # bluetooth
    nmgui # network manager
    dunst
    vlc

    # TOOLS
    brightnessctl
    pulseaudio
    redshift
    pamixer
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

  home.sessionVariables = {
    EDITOR = "neovim";
  };
}
