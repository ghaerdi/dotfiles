{config, ...}: {
  imports = [
    ./features/services.nix
    ./features/desktop.nix
    ./features/shell.nix
    ./features/work.nix
  ];
  home = {
    username = "vanzuh";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05"; # Please read releases notes before changing.
    file = {
      ".config/picom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/picom/.config/picom";
      ".config/kanata".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/kanata/.config/kanata";
      ".config/polybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/polybar/.config/polybar";
      ".config/qtile".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/qtile/.config/qtile";
      ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dunst/.config/dunst";
      ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/rofi/.config/rofi";
      ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux/.config/tmux";
      ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm/.wezterm.lua";
      ".config/espanso".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/espanso/.config/espanso";
      ".local/share/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fastfetch/.local/share/fastfetch";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
      ".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/starship/.config/starship";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/yazi/.config/yazi";
      ".xprofile".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/xprofile/.xprofile";
      ".themes".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/themes/.themes";
    };
  };
}
