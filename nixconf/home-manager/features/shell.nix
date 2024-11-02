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
    zoxide
    pyenv
    tmux
    htop
    eza
    bat
    fzf
    (pkgs.writeShellScriptBin "greet" ''
      echo "hello, ${config.home.username}!" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat
    '')

    (pkgs.writeShellScriptBin "bonsai" ''
      ${pkgs.cbonsai}/bin/cbonsai \
        -L 60 -M 12 -p -m "grew up in nixos btw"
    '')
  ];
  programs.starship.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit =
      /*
      fish
      */
      ''
        set fish_greeting ""

        alias sdn="shutdown now"
        alias c="clear"
        alias ls="eza"
        alias la="eza -a"
        alias ll="eza -l"
        alias lt="eza -aT"
        alias visudo="sudo EDITOR=nvim visudo"
        alias aic="~/.bun/bin/aic -t conventional -g 4"

        set EDITOR nvim

        set fish_user_paths $fish_user_paths /bin/fastfetch

        function random_propmt
        	set scripts "fastfetch --config arch" "fastfetch --config minimal"

        	set random_index (math (random) % (count $scripts) + 1)
        	eval $scripts[$random_index]
        end

        random_propmt

        starship init fish | source
        zoxide init fish | source
        pyenv init - | source
      '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf;
      }
    ];
  };
}
