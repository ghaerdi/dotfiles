{config, ...}: {
  systemd.services.supergfxd.path = [pkgs.pciutils];
  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
