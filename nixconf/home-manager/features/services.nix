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
        Type = "simple";
        ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${config.home.homeDirectory}/.config/kanata/kanata.kbd";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
    ollama = {
      Unit = {
        Description = "Ollama service";
      };
      Service = {
        ExecStart = "${pkgs.ollama}/bin/ollama serve";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
    # open-webui = {
    #     Unit = {
    #       Description = "Open webui service";
    #     };
    #     Service = {
    #       ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
    #     };
    #     Install = {
    #       WantedBy = ["default.target"];
    #     };
    # };
  };
}
