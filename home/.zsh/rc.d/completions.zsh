# set function paths
if has_brew; then
    fpath+=(${BREW_ZSH_SHARE_PREFIX}/zsh-completions)
    fpath+=(${BREW_ZSH_SHARE_PREFIX}/zsh/site-functions)
fi

# completion menu behaviour
setopt menu_complete
setopt auto_menu
setopt list_rows_first
zstyle ':completion:*' rehash true

# completion menu appearance
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# completion matching behaviour
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
setopt complete_in_word
setopt always_to_end
setopt glob_complete

# filesystem completions
_comp_options+=(globdots)
zstyle ':completion:*' special-dirs false

# init completions
autoload -Uz compinit
compinit

