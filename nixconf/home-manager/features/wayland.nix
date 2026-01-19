{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    espanso-wayland
    wl-clipboard
    hyprpicker
    hypridle
    hyprlock
    cliphist
    waybar
    slurp
    pywal
    rofi
    bemoji
    grim

    # wallpaper
    waypaper
    swww
  ];
}
