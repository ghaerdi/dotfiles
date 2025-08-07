{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    espanso-wayland
    rofi-wayland
    wl-clipboard
    hyprpicker
    hyprpaper
    hyprlock
    hyprsunset
    cliphist
    waybar
    slurp
    pywal
    grim
    swww
  ];
}
