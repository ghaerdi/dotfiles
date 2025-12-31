{
  config,
  lib,
  ...
}: {
  imports = [
    ../../home-manager/home.nix
    ../../home-manager/features/services.nix
    ../../home-manager/features/desktop.nix
    ../../home-manager/features/stylix.nix
    ../../home-manager/features/shell.nix
    ../../home-manager/features/work.nix
    ../../home-manager/features/wayland.nix

    ../../home-manager/scripts/asus-proart-kbd-backlight.nix
    ../../home-manager/scripts/bluetooth.nix
    ../../home-manager/scripts/brightness.nix
    ../../home-manager/scripts/clipboard.nix
    ../../home-manager/scripts/dnd.nix
    ../../home-manager/scripts/hyprland-window-pop.nix
    ../../home-manager/scripts/network.nix
    ../../home-manager/scripts/night-mode.nix
    ../../home-manager/scripts/prompt.nix
    ../../home-manager/scripts/screenshot.nix
    ../../home-manager/scripts/select-wallpaper.nix
    ../../home-manager/scripts/volume.nix
    ../../home-manager/scripts/webapp-launcher.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "mongodb-compass"
      "veracrypt"
      "obsidian"
      "slack"
    ];
}
