{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [slack awscli2 mongodb-compass zoom-us];
}
