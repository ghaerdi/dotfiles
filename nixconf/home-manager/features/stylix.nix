{pkgs, ...}: {
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = ../../../wallpapers/Wallpapers/space-dark.png;
  stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
  };
  stylix.opacity = {
    terminal = 0.9;
    popups = 0.9;
    desktop = 0.9;
  };
  stylix.fonts = {
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix.iconTheme = {
    enable = true;
    package = pkgs.gruvbox-dark-icons-gtk;
    dark = "Gruvbox-Plus-Dark";
    light = "Gruvbox-Plus-Light";
  };
  stylix.targets = {
    firefox.enable = false;
    fish.enable = false;
    vim.enable = false;
    helix.enable = false;
    kitty.enable = false;
    foot.enable = false;
  };
}
