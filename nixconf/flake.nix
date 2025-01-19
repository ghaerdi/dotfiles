{
  description = "Vanzuh's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "vanzuh";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05"; # Please read releases notes before changing.
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "vanzuh@nixos" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          username = username;
          homeDirectory = homeDirectory;
          stateVersion = stateVersion;
        };
        pkgs = pkgs;
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
