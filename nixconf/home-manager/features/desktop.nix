{
  pkgs,
  pkgs-stable,
  config,
  lib,
  ...
}: {
  programs.home-manager.enable = true;
  programs.brave = {
    enable = true;
    package = pkgs-stable.brave;
    extensions = [
      {id = "hdokiejnpimakedhajhdlcegeplioahd";}
    ];
  };

  programs.wezterm = {
    enable = true;
    package = pkgs-stable.wezterm;
  };

  home.packages = with pkgs; [
    # GUI
    rofi
    dunst
    telegram-desktop
    vesktop
    spicetify-cli
    spotify
    pavucontrol
    obsidian

    # TOOLS
    gnome-screenshot
    brightnessctl
    pulseaudio
    redshift
    espanso
    blueman
    kanata
    neovim
    xcolor
    volctl
    picom
    yazi
    feh

    # PROGRAMMING & DEPENDENCIES
    haskellPackages.greenclip
    xorg.xmodmap
    nodejs
    rustup
    zig
    bun
    gcc
    go

    # Fonts
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
      "obsidian"
      "slack"
    ];
  nixpkgs.config.pulseaudio = true;

  services.syncthing = {
    enable = true;
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
