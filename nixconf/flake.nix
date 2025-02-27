{
  description = "Vanzuh's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";
    swww.url = "github:LGFae/swww";
  };

  outputs = {
    nixpkgs,
    home-manager,
    zen-browser,
    hyprland,
    stylix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "vanzuh";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05"; # Please read releases notes before changing.
    zen = zen-browser.packages.${system};
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/laptop/configuration.nix
          stylix.nixosModules.stylix
        ];
      };

      qtile = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/qtile/configuration.nix
          stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      "vanzuh@laptop" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          zen-browser = zen.twilight;
          username = username;
          homeDirectory = homeDirectory;
          stateVersion = stateVersion;
        };
        pkgs = pkgs;
        modules = [
          stylix.homeManagerModules.stylix
          ./hosts/laptop/home-manager.nix
        ];
      };
      "vanzuh@qtile" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          zen-browser = zen.twilight;
          username = username;
          homeDirectory = homeDirectory;
          stateVersion = stateVersion;
        };
        pkgs = pkgs;
        modules = [
          stylix.homeManagerModules.stylix
          ./hosts/qtile/home-manager.nix
        ];
      };
    };
  };
}
