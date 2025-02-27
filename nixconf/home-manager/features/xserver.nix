{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    gnome-screenshot
    espanso
    rofi
  ];
}
