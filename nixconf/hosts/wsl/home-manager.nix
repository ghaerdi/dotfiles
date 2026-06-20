{
  config,
  lib,
  stateVersion,
  homeDirectory,
  username,
  ...
}: {
  imports = [
    ../../home-manager/features/shell.nix
    ../../home-manager/scripts/prompt.nix
    ../../home-manager/scripts/cleanup.nix
  ];
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = stateVersion;
    file = {
      ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/zellij/.config/zellij";
      ".local/share/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/fastfetch/.local/share/fastfetch";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/nvim/.config/nvim";
      ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/starship/.config/starship.toml";
      ".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/opencode/.config/opencode";
      ".agents".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/opencode/.agents";
      ".config/television".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/television/.config/television";
      ".config/worktrunk".source = config.lib.file.mkOutOfStoreSymlink "${homeDirectory}/dotfiles/worktrunk/.config/worktrunk";
    };
  };
}
