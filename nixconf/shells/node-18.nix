let
  nixpkgsRevision = "a71323f68d4377d12c04a5410e214495ec598d4c"; # Replace with an actual commit hash
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/${nixpkgsRevision}.tar.gz") {};
in
  pkgs.mkShell {
    packages = [pkgs.nodejs_18 pkgs.libuuid]; # Or try pkgs.nodejs_18

    env = {LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];};

    shellHook = ''
      echo "Node.js version requested: 18.18.x (via pinned Nixpkgs)"
      echo "Node.js version actual: $(node --version)"
      echo "npm version actual: $(npm --version)"
    '';
  }
