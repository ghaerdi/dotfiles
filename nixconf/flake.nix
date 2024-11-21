{
  description = "Vanzuh's nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser-pkg.url = "github:MarceColl/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    zen-browser-pkg,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    zen-browser = zen-browser-pkg.packages.${system}.default;
  in {
    formatter.${system} = pkgs-unstable.alejandra;

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
          pkgs-stable = pkgs;
          zen-browser = zen-browser;
        };
        pkgs = pkgs-unstable;
        modules = [./home-manager/home.nix];
      };
    };
  };
}
