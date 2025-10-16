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
    ../../home-manager/features/xserver.nix
    ../../home-manager/scripts/kbd-backlight-toggle.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "mongodb-compass"
      "veracrypt"
      "obsidian"
      "slack"
    ];
}
