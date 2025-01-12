{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../home-manager/features/battery.nix
  ];
  boot = {
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
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

  fileSystems."/mnt/personal" = {
    device = "/dev/nvme1n1p2";
    fsType = "ntfs-3g";
    options = ["rw" "uid=1000"];
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

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

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
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
      displayManager.gdm.enable = true;
      windowManager.qtile.enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = false;
      pulse.enable = true;
      jack.enable = false;
    };
    libinput.enable = true;
    # Enable the OpenSSH daemon.
    # openssh.enable = true;
  };

  users = {
    groups = {
      uinput = {};
    };
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.vanzuh = {
      isNormalUser = true;
      description = "Vanzuh";
      extraGroups = ["networkmanager" "audio" "docker" "wheel" "uinput" "input" "disk" "floppy" "storage"];
      shell = pkgs.fish;
      packages = with pkgs; [
        wezterm
        networkmanagerapplet
        xlayoutdisplay
        home-manager
        polybar
        picom
        stow
        git
      ];
    };
  };

  programs = {
    fish.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      xlayoutdisplay
      home-manager
      wezterm
      neovim
      git
    ];
    # variables = {
    #   GDK_SCALE = "1.5";
    #   GDK_DPI_SCALE = "0.5";
    #   _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    # };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
