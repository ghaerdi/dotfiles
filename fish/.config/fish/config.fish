if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting ""

# Aliases
alias sdn="shutdown now"
alias c="clear"
alias ls="exa"
alias la="exa -a"
alias ll="exa -l"
alias lt="exa -aT"
alias visudo="sudo EDITOR=nvim visudo"
alias aic="~/.bun/bin/aic -t conventional -g 4"

set EDITOR nvim

set fish_user_paths $fish_user_paths /bin/fastfetch

function random_propmt
	set scripts "taskbook" "fastfetch --config arch" "fastfetch --config minimal"

	set random_index (math (random) % (count $scripts) + 1)
	eval $scripts[$random_index]
end

random_propmt

# Starship (keep at the end of line)
starship init fish | source
zoxide init fish | source
pyenv init - | source
