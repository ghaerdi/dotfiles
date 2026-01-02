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
  };

  outputs = {
    nixpkgs,
    home-manager,
    zen-browser,
    stylix,
    quickshell,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "ghaerdi";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11"; # Please read releases notes before changing.
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      asus-proart = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          username = username;
          stateVersion = stateVersion;
        };
        modules = [
          ./hosts/asus-proart/configuration.nix
          stylix.nixosModules.stylix
        ];
      };

      isoimage = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/isoimage/configuration.nix
          stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      asus-proart = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          zen-browser = zen-browser.packages.${system}.twilight;
          quickshell = quickshell.packages.${system}.default;
          username = username;
          homeDirectory = homeDirectory;
          stateVersion = stateVersion;
        };
        pkgs = pkgs;
        modules = [
          stylix.homeModules.stylix
          ./hosts/asus-proart/home-manager.nix
        ];
      };
    };
  };
}
