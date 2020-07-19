#
# ~/.bashrc
#

# If not rIunning interactively, don't do anything
# [[ $- != *i* ]] && return

# alias ls='ls --color=auto'
# alias battery="upower -i `upower -e | grep BAT` | grep percentage | sed 's/ * / /g'"

. ~/.git-prompt.sh
#export PATH="~/Programacion/automatizacion:$PATH"
#export GIT_PS1_SHOWDIRTYSTATE=1
export PS1='\[\033[01;32m\]\u\[\033[01;34m\]>\[\033[33m\]\W\[\033[01;34m\]>>\[\033[00m\] '