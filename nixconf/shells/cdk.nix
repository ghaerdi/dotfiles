let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    packages = [
      pkgs.ssm-session-manager-plugin
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.pexpect
        python-pkgs.requests
        python-pkgs.boto3
      ]))
    ];
  }
