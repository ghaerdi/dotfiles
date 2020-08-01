#
# ~/.bashrc
#

# Terminal
. ~/.git-prompt.sh
export PS1='\[\033[01;32m\]\u\[\033[01;34m\]>\[\033[33m\]\W\[\033[01;34m\]>>\[\033[00m\] '

# Alias 
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
