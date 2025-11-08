{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    espanso-wayland
    wl-clipboard
    hyprpicker
    hyprsunset
    hyprpaper
    hyprlock
    cliphist
    waybar
    slurp
    pywal
    rofi
    grim
    swww
  ];
}
