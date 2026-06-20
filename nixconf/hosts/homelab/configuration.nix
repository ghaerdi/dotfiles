{ ... }: {
  imports = [
		../wsl/configuration.nix
  ];

	services.immich.enable = true;
	services.immich.port = 2283;
	services.immich.host = "0.0.0.0";
	services.immich.openFirewall = true;
	services.immich.mediaLocation = "/mnt/homelab/immich";
	services.immich.settings.server.externalDomain = "https://proteo.tailc96a5d.ts.net";
	systemd.tmpfiles.settings."10-immich" = {
		"/mnt/homelab/immich".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
		"/mnt/homelab/immich/thumbs".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
		"/mnt/homelab/immich/upload".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
		"/mnt/homelab/immich/backups".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
		"/mnt/homelab/immich/library".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
		"/mnt/homelab/immich/profile".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
		"/mnt/homelab/immich/encoded-video".d = {
			user = "immich";
			group = "immich";
			mode = "0755";
		};
	};
}
