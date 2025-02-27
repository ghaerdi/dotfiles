{
  config,
  username,
  homeDirectory,
  stateVersion,
  ...
}: {
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;
    file = {
      ".config/kanata".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/kanata/.config/kanata";
      ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/dunst/.config/dunst";
      ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/tmux/.config/tmux";
      ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/ghostty/.config/ghostty";
      ".config/espanso".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/espanso/.config/espanso";
      ".local/share/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/fastfetch/.local/share/fastfetch";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim/.config/nvim";
      ".config/starship".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/starship/.config/starship";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/yazi/.config/yazi";
      ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/rofi/.config/rofi";

      # xserver
      ".config/polybar".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/polybar/.config/polybar";
      ".config/qtile".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/qtile/.config/qtile";
      ".config/picom".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/picom/.config/picom";
      ".xprofile".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/xprofile/.xprofile";

      # wayland
      ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/hypr/.config/hypr";
      ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/waybar/.config/waybar";
      ".config/wal".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/wal/.config/wal";
    };
  };
}
