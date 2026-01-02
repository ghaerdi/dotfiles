{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    uutils-coreutils-noprefix
    fastfetch
    playerctl
    starship
    ripgrep
    wiremix
    killall
    ollama
    devenv
    neovim
    zoxide
    impala
    zellij
    gitui
    unzip
    cava
    yazi
    btop
    dust
    eza
    bat
    fzf
    fd
    xh

    lua-language-server
    python3
    nodejs
    zig
    bun
    gcc
    gopls
    go
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit =
      /*
      fish
      */
      ''
        # Check if the shell is interactive
            if status is-interactive
            # --- Functions ---
            # Function to display a random fetch prompt using fastfetch
            function random_propmt
            	# List of available fastfetch configurations
            	set -l scripts "nixconf-prompt" "fastfetch --config minimal" "fastfetch --config groups"

            	# Select a random index from the scripts list
            	set -l random_index (math (random) % (count $scripts) + 1)

            	# Execute the randomly selected fastfetch command
            	eval $scripts[$random_index]
            end

            # Disable the default Fish greeting message
            set fish_greeting ""

            # --- Aliases ---
            # System aliases
            alias sdn="shutdown now" # Alias for shutting down the system immediately
            alias c="clear"          # Alias for clearing the terminal screen

            # File listing aliases using eza (a modern replacement for ls)
            alias ls="eza"           # Basic listing
            alias la="eza -a"        # List all files, including hidden ones
            alias ll="eza -l"        # Long listing format
            alias lt="eza -aT"       # List all files in a tree format

            # Editing aliases
            alias visudo="sudo EDITOR=nvim visudo" # Edit the sudoers file using nvim with sudo privileges

            # --- Environment Variables ---
            # Set the default editor to nvim
            set EDITOR nvim

            # Add ~/.local/bin and the fastfetch binary path to the user's PATH
            # Ensures commands in these directories can be run directly
            set -U fish_user_paths $fish_user_paths /bin/fastfetch ~/.local/bin ~/.bun/bin

            # --- Integrations (Keep at the end) ---

            # Initialize Starship prompt - provides a customizable prompt
            # Check if starship is available before initializing
            if command -v starship > /dev/null
            		starship init fish | source
            end

            # Initialize zoxide - a smarter cd command
            # Check if zoxide is available before initializing
            if command -v zoxide > /dev/null
            		zoxide init fish | source
            end

            if not set -q IN_NIX_SHELL
            	if command -v pyenv > /dev/null
            	   pyenv init --path | source
            	end
            	random_propmt
            end
               end
      '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf;
      }
    ];
  };
}
