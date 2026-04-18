if [[ $(command -v nvim) ]]; then
    alias vim="nvim"

    MANPAGER="nvim +Man!"
    EDITOR=nvim

    # revert to emacs bindings in zle
    bindkey -e
fi

