if ! (( $+commands[fzf] )); then
    return
fi

source <(fzf --zsh)

export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

if (( $+commands[fd] )); then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

# ── shared fzf helpers ─────────────────────────────────────────────────────────

# Appends fzf selection(s) to the current line buffer, replacing the last word.
_fzf_replace_last_args() {
    local src_fn=$1
    local result
    result=$($src_fn) || { zle redisplay; return 0; }
    [[ -z $result ]] && { zle redisplay; return 0; }
    local quoted
    quoted=$(printf '%q ' ${(f)result})
    LBUFFER="${LBUFFER% *} $quoted"
    LBUFFER="${LBUFFER# }"
    zle redisplay
}

# ── smart Tab binding ──────────────────────────────────────────────────────────

_fzf_smart_tab() {
    local words
    words=("${(@Q)${(z)LBUFFER}}")
    local cmd=${words[1]}
    local subcmd=""
    local query=""

    # let normal completion handle options
    [[ ${words[-1]} == -* ]] && { zle expand-or-complete; return; }

    if (( $+commands[git] )) && [[ $cmd == "git" ]]; then
        subcmd=${words[2]}
        case $subcmd in
            add|update-index|rm|checkout|restore|diff)
                [[ ${words[-1]} != ($cmd|$subcmd|'**') ]] && query="${words[-1]}"
                zle _fzf_complete_git_files_widget "$query"
                return
                ;;
            stash)
                local stash_sub=${words[3]}
                [[ ${words[-1]} != ($cmd|$subcmd|$stash_sub|'**') ]] && query="${words[-1]}"
                case $stash_sub in
                    show|drop|pop|apply|branch)
                        zle _fzf_complete_git_stash_widget "$query"
                        return
                        ;;
                esac
                ;;
            show|cherry-pick|rebase|reset|revert)
                [[ ${words[-1]} != ($cmd|$subcmd|'**') ]] && query="${words[-1]}"
                zle _fzf_complete_git_commit_widget "$query"
                return
                ;;
        esac
    fi

    if (( $+commands[zoxide] )) && [[ $cmd == "z" || $cmd == "zi" ]]; then
        [[ ${words[-1]} != ($cmd|'**') ]] && query="${words[-1]}"
        zle _fzf_complete_zoxide_widget "$query"
        return
    fi

    zle expand-or-complete
}

zle -N _fzf_smart_tab
bindkey '^I' _fzf_smart_tab
