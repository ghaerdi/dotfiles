{
  pkgs,
  config,
  lib,
  zen-browser,
  quickshell,
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
    libreoffice
    eog # gnome image viewer
    evince # gnome document viewer
    quickshell
    telegram-desktop
    youtube-music
    pavucontrol
    zen-browser
    obs-studio
    obsidian
    vesktop
    ghostty
    vlc

    # TOOLS
    bluetui # bluetooth

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
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
