setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt extended_history
setopt share_history

setopt correct

setopt prompt_subst

_comp_options+=(globdots)
zstyle ':completion:*' special-dirs false
