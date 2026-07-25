#!/usr/bin/env zsh
# set function paths
if has_brew; then
    fpath+=(${BREW_ZSH_SHARE_PREFIX}/zsh/site-functions)
    fpath+=(${BREW_ZSH_SHARE_PREFIX}/zsh/functions)
    fpath+=(${BREW_ZSH_SHARE_PREFIX}/zsh-completions)
fi

# completion behaviour
zmodload zsh/complist
setopt always_to_end
setopt complete_in_word
setopt extended_glob
setopt glob_dots
setopt glob_complete
setopt auto_param_slash

# completers
zstyle ':completion:*' completer _expand _complete _match _correct _approximate
zstyle ':completion:*:correct:*' max-errors 1 numeric
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' keep-prefix true
zstyle ':completion:*' expand prefix
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' special-dirs false
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

# completer cache
zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

# completion menu
unsetopt menu_complete
setopt auto_list                   # first tab, show list
setopt auto_menu                   # second tab, show menu
zstyle ':completion:*' menu select # second tab, pre-select first match
setopt list_rows_first

# completion menu controls
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xi' vi-insert

# completion styles
zstyle ':completion:*' verbose yes
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# git
zstyle ':completion:*:git-*:*' group-name ''
zstyle ':completion:*:git-*:*:descriptions' format '%F{green}:: %d%f'
zstyle ':completion:*:git-*:*' tag-order 'options commands' '*'
zstyle ':completion:*:git-*:*' group-order options commands
zstyle ':completion:*:git:*' tag-order 'main-porcelain-commands aliases user-commands third-party-commands'

# ssh/scp/rsync
zstyle ':completion:*:(ssh|scp|rsync):*' group-name ''
zstyle ':completion:*:(ssh|scp|rsync):*:descriptions' format '%F{green}:: %d%f'
zstyle ':completion:*:(ssh|scp|rsync):*' sort false
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-domain:domain hosts:-host:host hosts:-ipaddr:ip\ address files'
zstyle ':completion:*:(scp|rsync):*' group-order hosts-domain hosts-host hosts-ipaddr files
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
zstyle -e ':completion:*:(ssh|scp|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# init completions
autoload -Uz compinit
compinit
