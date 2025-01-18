{
  pkgs,
  config,
  lib,
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
    obs-studio
    obsidian
    stremio
    vesktop
    dunst
    rofi

    # TOOLS
    ghostty
    gnome-screenshot
    brightnessctl
    pulseaudio
    redshift
    espanso
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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "mongodb-compass"
      "obsidian"
      "slack"
    ];
  nixpkgs.config.pulseaudio = true;

  services = {
    syncthing.enable = true;
  };

  qt.enable = true;
  qt.platformTheme.name = "gtk";
  gtk.enable = true;
  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";
  gtk.iconTheme.package = pkgs.gruvbox-plus-icons;
  gtk.iconTheme.name = "Gruvbox-Plus-Dark";
  gtk.cursorTheme.package = pkgs.catppuccin-cursors.frappeDark;
  gtk.cursorTheme.name = "catppuccin-frappe-dark-cursors";

  home.sessionVariables = {
    EDITOR = "neovim";
  };
}
