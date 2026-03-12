# set function paths
fpath+=(${ZSH_SHARE_PREFIX}/zsh-completions)
fpath+=(${ZSH_SHARE_PREFIX}/zsh/site-functions)

# completion menu behaviour
unsetopt menu_complete
setopt auto_menu
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# completion matching behaviour
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
setopt complete_in_word
setopt always_to_end

# filesystem completions
_comp_options+=(globdots)
zstyle ':completion:*' special-dirs false

# init completions
autoload -Uz compinit
compinit

