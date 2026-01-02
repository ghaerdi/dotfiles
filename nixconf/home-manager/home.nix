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
      ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/tmux/.config/tmux";
      ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/zellij/.config/zellij";
      "dotfiles/zellij/.config/zellij/themes/pywal.kdl".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/.cache/wal/zellij.kdl";
      ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/ghostty/.config/ghostty";
      ".config/espanso".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/espanso/.config/espanso";
      ".local/share/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/fastfetch/.local/share/fastfetch";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim/.config/nvim";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/starship/.config/starship.toml";
      ".config/yazi".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/yazi/.config/yazi";
      ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/rofi/.config/rofi";
      ".config/quickshell".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/quickshell/.config/quickshell";

      # wayland
      ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/hypr/.config/hypr";
      ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/waybar/.config/waybar";
      ".config/wal".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/wal/.config/wal";
      ".config/swaync".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/swaync/.config/swaync";
    };
  };
}
