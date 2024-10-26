{ config, pkgs, ... }:

{
  home.username = "vanzuh";
  home.homeDirectory = "/home/vanzuh";

  nixpkgs.config.allowUnfreePredicate =
    pkg: builtins.elem (pkgs.lib.getName pkg) [
      "spotify"
      "zoom"
      "obsidian"
      "slack"
    ];

  nixpkgs.config.pulseaudio = true;

  home.packages = with pkgs; [
    # GUI
    dunst
    rofi
    rofi-calc
    rofi-emoji
    rofi-power-menu
    telegram-desktop
    vesktop
    zoom-us
    spicetify-cli
    spotify
    pavucontrol
    obsidian
    slack

    # TUI & TOOLS
    volctl
    gnome-screenshot
    brightnessctl
    pulseaudio
    redshift
    xcolor
    neovim
    fastfetch
    starship
    tmux
    yazi
    eza
    bat
    ripgrep
    fzf
    htop
    zoxide
    espanso
    blueman
    kanata
    killall
    picom
    feh

    # PROGRAMMING & DEPENDENCIES
    nodejs
    rustup
    pyenv
    zig
    bun
    go
    gcc
    haskellPackages.greenclip
    xorg.xmodmap

    # Fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    (pkgs.writeShellScriptBin "greet" ''
      echo "Hello, ${config.home.username}!" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
    '')

    (pkgs.writeShellScriptBin "bonsai" ''
      ${pkgs.cbonsai}/bin/cbonsai \
        -L 60 -M 12 -p -m "grew up in nixos btw"
    '')
  ];

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/picom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/picom/.config/picom";
    ".config/polybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/polybar/.config/polybar";
    ".config/qtile".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/qtile/.config/qtile";
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dunst/.config/dunst";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/rofi/.config/rofi";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux/.config/tmux";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm/.wezterm.lua";
    ".config/espanso".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/espanso/.config/espanso";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fish/.config/fish";
    ".local/share/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fastfetch/.local/share/fastfetch";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship/.config/starship";
    ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/yazi/.config/yazi";
    ".xprofile".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/xprofile/.xprofile";
    ".themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/themes/.themes";
  };

  home.sessionVariables = {
    EDITOR = "neovim";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "24.05"; # Please read releases notes before changing.
}
