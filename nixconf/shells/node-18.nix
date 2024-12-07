let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [pkgs.nodejs_18 pkgs.libuuid];
    env = {LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.libuuid];};
    shellHook = ''
      echo Node.js version: $(node --version)
    '';
  }