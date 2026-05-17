{
  config,
  pkgs,
  ...
}: {
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa # Music player
    kdePackages.kdepim-runtime # Akonadi agents
    kdePackages.kmahjongg
    kdePackages.kmines
    kdePackages.konversation # IRC client
    kdePackages.kpat # Solitaire
    kdePackages.ksudoku
    kdePackages.ktorrent
    kdePackages.discover
    kdePackages.kwrited
    kdePackages.konsole
    kdePackages.okular
    kdePackages.kate
  ];
}
