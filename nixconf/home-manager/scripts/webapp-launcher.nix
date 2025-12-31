{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "nixconf-webapp-launcher" ''
      #!/bin/bash

      browser=$(${pkgs.xdg-utils}/bin/xdg-settings get default-web-browser)

      case $browser in
      google-chrome* | brave-browser* | microsoft-edge* | opera* | vivaldi* | helium-browser*) ;;
      *) browser="chromium.desktop" ;;
      esac

      browser_exec=$(${pkgs.gnused}/bin/sed -n 's/^Exec=\([^ ]*\).*/\1/p' {~/.local,~/.nix-profile,/usr}/share/applications/$browser 2>/dev/null | ${pkgs.coreutils}/bin/head -1)

      if [ -z "$browser_exec" ] || [ "$browser" = "chromium.desktop" ]; then
        browser_exec="${pkgs.brave}/bin/brave"
      fi

      exec ${pkgs.util-linux}/bin/setsid -f $browser_exec --app="$1" "''${@:2}"
    '')
  ];
}
