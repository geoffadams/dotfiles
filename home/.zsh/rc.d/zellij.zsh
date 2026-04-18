if [[ -n $ZELLIJ ]]; then
    source $HOME/.zprofile
    if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
    fi
fi

if [[ $(command -v zellij) ]]; then
    alias zz="zellij"
    alias zzl="zellij ls"
    alias zzd="zellij d"

    if [[ $(command -v fzf) ]]; then
        zza() {
            if [[ -z "$1" ]]; then
                zellij a -c $(zellij ls -s | fzf)
            else
                zellij a -c "$1"
            fi
        }
    else
        alias zza="zellij a -c"
    fi

    zzr() {
        zellij d $1
        zellij a -c $1
    }

    zzrf() {
        zellij d --force $1
        zellij a -c $1
    }
fi
