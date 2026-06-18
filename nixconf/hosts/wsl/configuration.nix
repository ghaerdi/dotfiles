{
  inputs,
  lib,
  pkgs,
  stateVersion,
  username,
  hostname,
  ...
}: {
  imports = [
    /etc/nixos/configuration.nix
    /etc/nixos/hardware-configuration.nix
    # ./features/cachix.nix
    # ./features/stylix.nix
    # <nixos-wsl/modules>
  ];

  time.timeZone = "America/Santiago";
  wsl.defaultUser = lib.mkForce username;

  networking.hostName = hostname;

  services.tailscale.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  users = {
    groups = {
      uinput = {};
    };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.${username} = {
      isNormalUser = true;
      initialPassword = "password";
      description = "Gil Rudolf Härdi";
      extraGroups = ["networkmanager" "audio" "docker" "wheel" "uinput" "input" "disk" "floppy" "storage"];
      shell = pkgs.fish;
    };
  };

  networking.resolvconf.enable = false;

  programs = {
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    git
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkForce stateVersion; # Did you read the comment?
}
