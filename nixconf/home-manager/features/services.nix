{
  pkgs,
  config,
  ...
}: {
  systemd.user.services = {
    kanata = {
      Unit = {
        Description = "Kanata keyboard remapper";
        Documentation = "https://github.com/jtroo/kanata";
      };
      Service = {
        Restart = "always";
        RestartSec = "3";
        Type = "simple";
        ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${config.home.homeDirectory}/.config/kanata/kanata.kbd";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
