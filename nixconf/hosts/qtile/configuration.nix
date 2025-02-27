{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../nixos/configuration.nix
    ../../nixos/features/nvidia.nix
    ../../nixos/features/steam.nix
    ../../nixos/features/battery.nix
  ];
  services = {
    pulseaudio.enable = false;
    xserver.windowManager.qtile = {
      enable = true;
    };
  };
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # nvidia
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
      # steam
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
}
