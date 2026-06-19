{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
		./base-configuration.nix
    ./features/cachix.nix
    ./features/stylix.nix
  ];

  boot = {
    supportedFilesystems = ["ntfs" "ntfs-3g"];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
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
        configurationLimit = 10;
      };
    };
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      wifi.backend = "iwd";
    };
  };

  hardware = {
    firmware = [pkgs.linux-firmware];
    enableAllFirmware = true;
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  powerManagement = {
    enable = true;
  };

  security.rtkit.enable = true;

  virtualisation.docker = {
    storageDriver = "btrfs";
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

  programs = {
    nix-ld.enable = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.swww.packages.${stdenv.hostPlatform.system}.swww
    # home-manager
    ntfs3g
    # neovim
    # git
  ];
}
