{
  config,
  lib,
  stable-pkgs,
  ...
}: {
  services.xserver.videoDrivers = ["nvidia" "amdgpu"];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    open = false;
    nvidiaSettings = true;
    prime = {
      amdgpuBusId = "PCI:102:0:0";
      nvidiaBusId = "PCI:101:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
