let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [pkgs.nodejs_22 pkgs.libuuid];

    env = {LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];};

    shellHook = ''
      echo "Node.js version requested: 22.x (via Nixpkgs)"
      echo "Node.js version actual: $(node --version)"
      echo "npm version actual: $(npm --version)"
    '';
  }
