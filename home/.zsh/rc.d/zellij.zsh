if [[ -n $ZELLIJ ]]; then
    source $HOME/.zprofile
    if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
        source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
    fi
fi

if [[ $(command -v zellij) ]]; then
    alias zz="zellij"
    alias zzl="zellij ls -r"

    if [[ $(command -v fzf) ]]; then
        zza() {
            local session
            if [[ -z "$1" ]]; then
                session=$(zellij ls -s | fzf --height=~40% --layout=reverse --info=inline --border --margin=1)
            fi
            zellij a -c "$session"
        }
        zzs() {
            local host
            local session
            host=$1
            if [[ -z "$host" ]]; then
                host=$(grep -E '^Host [^\*]' ~/.ssh/config | awk '{print $2}' | fzf --height=~40% --layout=reverse --info=inline --border --margin=1)
            fi
            session=$2
            if [[ -z "$session" ]]; then
                session=$(ssh $host -t "zellij ls -rs" 2>/dev/null | fzf --height=~40% --layout=reverse --info=inline --border --margin=1)
            fi
            ssh $host -t "zellij a -c $session"
        }
    else
        alias zza="zellij a -c"
        zzs() {
            ssh $1 -t "zellij a -c $2"
        }
    fi

    zzd() { zellij d "$@" }
    zzr() {
        zellij d $1
        zellij a -c $1
    }
    zzrf() {
        zellij d --force $1
        zellij a -c $1
    }

    # Completions
    _zellij_sessions() {
        local -a sessions
        sessions=(${(f)"$(zellij ls -s 2>/dev/null)"})
        _describe 'zellij session' sessions
    }

    _zzd()  { _zellij_sessions }
    _zza()  { _zellij_sessions }
    _zzr()  { _zellij_sessions }
    _zzrf() { _zellij_sessions }

    _zzs() {
        local state
        _arguments \
            '1:SSH host:->host' \
            '2:remote session:->session'
        case $state in
            host)
                _ssh_hosts
                ;;
            session)
                local host=${words[2]}
                local sessions
                sessions=(${(f)"$(ssh "$host" -t "zellij ls -rs" 2>/dev/null | tr -d '\r')"})
                _describe 'remote session' sessions
                ;;
        esac
    }

    compdef _zzd zzd
    compdef _zza zza
    compdef _zzr zzr
    compdef _zzrf zzrf
    compdef _zzs zzs
fi
