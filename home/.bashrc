# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_pv

source ~/env.sh
source /usr/share/bash-completion/completions/git
