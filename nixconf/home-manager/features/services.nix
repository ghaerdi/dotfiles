{
  pkgs,
  config,
  ...
}: {
  services = {
    kdeconnect.enable = true;
    syncthing.enable = true;
    udiskie = {
      enable = true;
      settings = {
        program_options = {
          automount = true;
          notify = true;
        };
        mount_options = [
          {
            device_label = "SHARGE_SSD";
            options = ["compress=zstd" "noatime" "user" "exec"];
          }
        ];
      };
    };
  };
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
  };
}
