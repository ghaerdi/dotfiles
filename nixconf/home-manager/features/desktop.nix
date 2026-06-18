{
  pkgs,
  zen-browser,
  quickshell,
	spicePkgs,
  ...
}: {
  programs.home-manager.enable = true;
  programs.brave = {
    enable = true;
    extensions = [
      {id = "hdokiejnpimakedhajhdlcegeplioahd";}
    ];

    commandLineArgs = [
      "--remote-debugging-port=9222"
      "--remote-allow-origins='*'"
    ];
  };

  home.packages = with pkgs; [
    # GUI
    swaynotificationcenter
    veracrypt
    gnome-calculator
    gnome-disk-utility
    libreoffice
    quickshell
    telegram-desktop
    kdePackages.kdenlive
    whatsapp-electron
    brightnessctl
    pavucontrol
    zen-browser
    obs-studio
    obsidian
    vesktop
    ghostty
    zed-editor
    vlc

    # TOOLS
    bluetui # bluetooth

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts
  ];

	programs.spicetify = {
		enable = true;
		theme = spicePkgs.themes.turntable;
		enabledExtensions = with spicePkgs.extensions; [
			hidePodcasts
			fullAppDisplay
		];
		enabledSnippets = with spicePkgs.snippets; [
			pointer
		];
		enabledCustomApps = with spicePkgs.apps; [
			marketplace
			ncsVisualizer
		];
	};

  fonts.fontconfig = {
    enable = true;
  };

  nixpkgs.config.pulseaudio = true;

  home.sessionVariables = {
    EDITOR = "neovim";
  };
}
