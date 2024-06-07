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
alias cat='bat'

set fish_user_paths $fish_user_paths /bin/fastfetch

function random_propmt
	set scripts "fastfetch --config arch" "fastfetch --config minimal" "colorscript -e panes" "colorscript -e blocks1" "colorscript -e bars"

	set random_index (math (random) % (count $scripts) + 1)
	eval $scripts[$random_index]
end

random_propmt

# set -l COMMANDS ( "fastfetch" "colorscript" )
# run (string pick $COMMANDS)


# Starship (keep at the end of line)
starship init fish | source
