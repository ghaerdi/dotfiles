{
  username,
  stateVersion,
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./features/stylix.nix
    ./features/cachix.nix
  ];

  boot = {
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = false;
      grub = {
        enable = true;
        useOSProber = true;
        device = "nodev";
        efiSupport = true;
      };
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.iwd.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.settings.Settings.AutoConnect = true;
    firewall = rec {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          AutoEnable = false;
        };
        Policy = {
          AutoEnable = false;
        };
      };
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  time.timeZone = "America/Santo_Domingo";

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

  security.rtkit.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  services = {
    printing.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    udev.packages = [
      (pkgs.writeTextFile {
        name = "uinput";
        text = ''
          KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
        '';
        destination = "/etc/udev/rules.d/99-input.rules";
      })
    ];
    udev.extraRules = ''
      SUBSYSTEM=="leds", KERNEL=="asus::kbd_backlight", ACTION=="add", RUN+="${pkgs.coreutils}/bin/chmod 664 /sys/class/leds/asus::kbd_backlight/brightness", RUN+="${pkgs.coreutils}/bin/chgrp wheel /sys/class/leds/asus::kbd_backlight/brightness"
    '';
    displayManager.gdm.enable = true;
    xserver = {
      enable = true;
      dpi = 276;
      xkb = {
        layout = "us";
        variant = "";
      };
      upscaleDefaultCursor = true;
    };
    libinput.enable = true;
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
      packages = with pkgs; [
        home-manager
        stow
        git
      ];
    };
  };

  programs = {
    fish.enable = true;
    nix-ld.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      inputs.swww.packages.${stdenv.hostPlatform.system}.swww
      home-manager
      ntfs3g
      neovim
      git
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = stateVersion; # Did you read the comment?
}
