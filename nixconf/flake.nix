{
  description = "Vanzuh's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser-pkg.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = {
    nixpkgs,
    zen-browser-pkg,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    zen-browser = zen-browser-pkg.packages.${system}.default;
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "vanzuh@nixos" = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          zen-browser = zen-browser;
        };
        pkgs = pkgs;
        modules = [
          ./home-manager/home.nix
        ];
      };
    };
  };
}
