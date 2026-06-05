{
  config,
  pkgs,
  inputs,
  stable-pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      linux-firmware-stable = prev.linux-firmware.overrideAttrs (oldAttrs: rec {
        version = "20250509";
        src = prev.fetchzip {
          url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz";
          hash = "sha256-0FrhgJQyCeRCa3s0vu8UOoN0ZgVCahTQsSH0o6G6hhY=";
        };
      });
      linux-firmware = final.linux-firmware-stable;
    })
  ];

  boot.kernelPackages = stable-pkgs.linuxPackages_latest;
}
