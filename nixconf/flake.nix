{
  description = "Nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Pinned nixpkgs for kernel 7.0.3 (Bluetooth MT7925 regression fix)
    nixpkgs-kernel.url = "github:nixos/nixpkgs/549bd84d6279f9852cae6225e372cc67fb91a4c1";
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
  };

  outputs = {
    nixpkgs,
    home-manager,
		spicetify-nix,
    nixpkgs-kernel,
    zen-browser,
    stylix,
    quickshell,
    ...
  } @ inputs: let
    system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
		stable-pkgs = import nixpkgs-kernel {
      inherit system;
      config.allowUnfree = true;
    };
    username = "ghaerdi";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11"; # Please read releases notes before changing.
  in {
    formatter.${system} = pkgs.alejandra;

    nixosConfigurations = {
      asus-proart = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs stateVersion username stable-pkgs;
          hostname = "proart-nixos";
        };
        modules = [
          ./hosts/asus-proart/configuration.nix
          stylix.nixosModules.stylix
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs stateVersion username stable-pkgs;
          hostname = "proteo";
        };
        modules = [
          ./hosts/wsl/configuration.nix
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
      wsl = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit inputs stateVersion username homeDirectory;
        };
        pkgs = pkgs;
        modules = [
          ./hosts/wsl/home-manager.nix
        ];
      };
    };
  };
}
