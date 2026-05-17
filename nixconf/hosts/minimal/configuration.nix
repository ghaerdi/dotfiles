{
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../nixos/configuration.nix
    ../../nixos/features/kde-plasma.nix
    ../../nixos/features/pipewire.nix
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "veracrypt"
      "obsidian"
    ];
}
