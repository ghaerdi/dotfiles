{
  pkgs,
  config,
  lib,
  ...
}: {
  home.packages = with pkgs; [slack awscli2 jq mongodb-compass];
}
