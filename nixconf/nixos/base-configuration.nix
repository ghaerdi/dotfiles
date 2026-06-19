{
  username,
  hostname,
  stateVersion,
  pkgs,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = hostname;
  time.timeZone = "America/Santiago";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "es_DO.UTF-8/UTF-8"];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;

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
      packages = with pkgs; [
        home-manager
        git
      ];
    };
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
    neovim
    git
  ];
}
