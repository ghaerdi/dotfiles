{
  config,
  pkgs,
  lib,
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
    open = true;
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
