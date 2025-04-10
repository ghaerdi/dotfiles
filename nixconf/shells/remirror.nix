{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  # These packages will be available in the shell
  buildInputs = [
    pkgs.git
    pkgs.nodejs # Includes corepack, needed for 'corepack enable' and running JS
    pkgs.nodePackages.pnpm # The specific package manager required

    # Common build tools needed for 'pnpm install' when native modules are involved
    pkgs.python3
    pkgs.gnumake
    pkgs.gcc
  ];

  # Optional: You can add commands to run when the shell starts
  shellHook = ''
    echo "Nix shell for remirror activated."
    corepack enable
  '';
}
