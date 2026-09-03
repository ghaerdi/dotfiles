{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    stylix.url = "github:danth/stylix";
    swww.url = "github:LGFae/swww";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    herdr.url = "github:ogulcancelik/herdr";
  };

  outputs = {
    nixpkgs,
    home-manager,
    spicetify-nix,
    zen-browser,
    stylix,
    quickshell,
    herdr,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [herdr.overlays.default];
    };
    username = "ghaerdi";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11"; # Please read releases notes before changing.
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      asus-proart = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs stateVersion username;
          hostname = "proart-nixos";
        };
        modules = [
          ./hosts/asus-proart/configuration.nix
          stylix.nixosModules.stylix
        ];
      };

      homelab = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs stateVersion username;
          hostname = "proteo";
        };
        modules = [
          ./hosts/homelab/configuration.nix
        ];
      };

      isoimage = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs stateVersion;
        };
        modules = [
          ./hosts/isoimage/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      asus-proart = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs stateVersion username homeDirectory;
          zen-browser = zen-browser.packages.${system}.twilight;
          quickshell = quickshell.packages.${system}.default;
          spicePkgs = spicetify-nix.legacyPackages.${system};
        };
        pkgs = pkgs;
        modules = [
          stylix.homeModules.stylix
          inputs.spicetify-nix.homeManagerModules.spicetify
          ./hosts/asus-proart/home-manager.nix
        ];
      };
      homelab = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs stateVersion username homeDirectory;
        };
        pkgs = pkgs;
        modules = [
          ./hosts/homelab/home-manager.nix
        ];
      };
    };
  };
}
