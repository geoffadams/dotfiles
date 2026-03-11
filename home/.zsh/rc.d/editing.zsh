[[ $(command -v bat) ]] && PAGER=bat
if [[ $(command -v nvim) ]]; then
    MANPAGER="nvim +Man!"
    EDITOR=nvim
fi
bindkey -e
