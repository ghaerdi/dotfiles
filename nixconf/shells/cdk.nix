let
  pkgs = import <nixpkgs> {};
  packageOverrides = pkgs.callPackage ./python-packages.nix {};
  python = pkgs.python3.override {inherit packageOverrides;};
in
  pkgs.mkShell {
    packages = with pkgs; [
      uv
      ssm-session-manager-plugin
      mongodb-tools
      (python3.withPackages (p:
        with p; [
          pexpect
          requests
          boto3
          pymongo
        ]))
      (python.withPackages (p:
        with p; [
          constructs
        ]))
    ];
    env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.stdenv.cc.cc.lib
      pkgs.libz
    ];
  }
