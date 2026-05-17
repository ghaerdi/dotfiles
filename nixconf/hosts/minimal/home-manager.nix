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

    ../../home-manager/scripts/cleanup.nix
  ];
}
