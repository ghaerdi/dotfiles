{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fastfetch
    starship
    ripgrep
    killall
    ollama
    neovim
    zoxide
    aichat
    pyenv
    unzip
    tmux
    yazi
    btop
    eza
    bat
    fzf

    lua-language-server
    python3
    nodejs
    rustup
    deno
    zig
    bun
    gcc
    gopls
    go
  ];
  programs.starship.enable = true;
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
        	set -l scripts "fastfetch --config arch" "fastfetch --config minimal"

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

        # Git commit alias using aic (AI Commits tool)
        alias aic="~/.bun/bin/aic -t conventional -g 4" # Generate conventional commit messages using AI

        # --- Environment Variables ---
        # Set the default editor to nvim
        set EDITOR nvim

        # Add ~/.local/bin and the fastfetch binary path to the user's PATH
        # Ensures commands in these directories can be run directly
        set -U fish_user_paths $fish_user_paths /bin/fastfetch ~/.local/bin

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
