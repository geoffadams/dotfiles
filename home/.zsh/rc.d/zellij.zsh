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
                session=$(zellij ls -s | fzf --height=~40% --layout=reverse --info=inline --border --margin=1)
            fi
            zellij a -c "$session"
        }
        zzs() {
            host=$1
            if [[ -z "$host" ]]; then
                host=$(grep -E '^Host [^\*]' ~/.ssh/config | awk '{print $2}' | fzf --height=~40% --layout=reverse --info=inline --border --margin=1)
            fi
            session=$2
            if [[ -z "$session" ]]; then
                session=$(ssh $host -t "zellij ls -s" 2>/dev/null | fzf --height=~40% --layout=reverse --info=inline --border --margin=1)
            fi
            ssh $host -t "zellij a -c $session"
        }
    else
        alias zza="zellij a -c"
        zzs() {
            ssh $1 -t "zellij a -c $2"
        }
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
