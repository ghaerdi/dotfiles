{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../nixos/configuration.nix
    ../../nixos/features/cachix.nix
    ../../nixos/features/nvidia.nix
    ../../nixos/features/battery.nix
    ../../nixos/features/hyprland.nix
    ../../nixos/features/pipewire.nix
    ../../nixos/features/steam.nix
    ../../nixos/features/gnome.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # nvidia
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
      "cuda-merged"
      # steam
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
}
