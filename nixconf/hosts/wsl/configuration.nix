{
  lib,
  username,
  ...
}: {
  imports = [
    /etc/nixos/configuration.nix
    /etc/nixos/hardware-configuration.nix
		../../nixos/base-configuration.nix
  ];

  wsl.defaultUser = lib.mkForce username;

  services.tailscale.enable = true;

  networking.resolvconf.enable = false;
}
