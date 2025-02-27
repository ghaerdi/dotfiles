{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    espanso-wayland
    rofi-wayland
    playerctl
    wl-clipboard
    hyprpicker
    hyprpaper
    hyprlock
    hyprsunset
    cliphist
    waybar
    pywal
    swww
  ];
}
