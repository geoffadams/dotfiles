export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000000
export SAVEHIST=100000

# share history between sessions
setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt extended_history
setopt share_history
