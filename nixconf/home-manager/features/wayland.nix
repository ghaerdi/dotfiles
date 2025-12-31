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
    hypridle
    hyprlock
    cliphist
    waybar
    slurp
    pywal
    rofi
    bemoji
    grim
    swww
  ];
}
