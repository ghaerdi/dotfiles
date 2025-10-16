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
    swaynotificationcenter
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
    nmgui # network manager
    vlc

    # TOOLS
    brightnessctl
    pulseaudio
    libnotify
    redshift
    pamixer
    bluetui # bluetooth
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
  ];

  fonts.fontconfig = {
    enable = true;
  };

  nixpkgs.config.pulseaudio = true;

  home.sessionVariables = {
    EDITOR = "neovim";
  };
}
