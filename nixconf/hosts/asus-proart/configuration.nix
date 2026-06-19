{ lib, ... }:
{
  imports = [
    ../../nixos/configuration.nix
    ../../nixos/features/battery.nix
    ../../nixos/features/hyprland.nix
    ../../nixos/features/niri.nix
    ../../nixos/features/pipewire.nix
    ../../nixos/features/steam.nix
    ../../nixos/features/kde-plasma.nix
    ./overlays/linux-stable.nix
    ./features/nvidia.nix
  ];

  boot = {
    resumeDevice = "/dev/disk/by-label/swap";
    kernelParams = [
      "mt7925e.disable_aspm=1"
      "usbcore.quirks=0489:e11e:k"
    ];
  };

  services.tailscale.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "broadcom-bt-firmware"
      "b43-firmware"
      "xone-dongle-firmware"
      "facetimehd-calibration"
      "facetimehd-firmware"
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
}
