{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = false;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
}
