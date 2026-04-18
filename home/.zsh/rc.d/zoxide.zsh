if [[ $(command -v zoxide) ]]; then
    eval "$(zoxide init zsh)"

    if [[ $(command -v fzf) ]]; then
        function zoxide_fzf() {
            local orig_buffer=$LBUFFER
            local selection
            selection=$(zoxide query --list | fzf --height 40% --reverse) || {
                LBUFFER=$orig_buffer
                zle redisplay
                return 0
            }

            if [[ -n "$selection" ]]; then
                LBUFFER="cd $selection"
                zle redisplay
            fi
        }
        zle -N zoxide_fzf
        bindkey '^O' zoxide_fzf
    fi
fi
