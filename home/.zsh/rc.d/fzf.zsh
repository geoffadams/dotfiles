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
    local src_query=$2
    local result
    result=$($src_fn $src_query) || { zle redisplay; return 0; }
    [[ -z $result ]] && { zle redisplay; return 0; }
    local quoted
    quoted=$(printf '%q ' ${(f)result})
    LBUFFER="${LBUFFER% *} $quoted"
    LBUFFER="${LBUFFER# }"
    zle redisplay
}

# ── smart Tab binding ──────────────────────────────────────────────────────────

_fzf_smart_tab() {
    local words=("${(@Q)${(z)LBUFFER}}")
    local cmd=${words[1]}
    local subcmd
    local query

    # let normal completion handle options; '--' is only a file delimiter when followed by a space
    [[ ${words[-1]} == -* ]] && [[ ${words[-1]} != '--' || $LBUFFER[-1] != ' ' ]] && { zle expand-or-complete; return; }

    if (( $+commands[git] )) && [[ $cmd == "git" ]]; then
        subcmd=${words[2]}

        # '--' after the subcommand means everything following is a file path
        # (I) returns the index of the last match, or 0 if not found
        if (( ${words[(I)--]} >= 3 )); then
            [[ ${words[-1]} != '--' ]] && query=${words[-1]}
            zle _fzf_complete_git_files_widget "$query"
            return
        fi

        case $subcmd in
            add|update-index|rm|restore|diff)
                if [[ ${#words[@]} > 2 && ${words[-1]} != '**' ]]; then
                    query=${words[-1]}
                fi
                zle _fzf_complete_git_files_widget "${query}"
                return
                ;;
            stash)
                local stash_subcmd=${words[3]}
                case $stash_subcmd in
                    show|drop|pop|apply|branch)
                        if [[ ${#words[@]} > 3 && ${words[-1]} != '**' ]]; then
                            query=${words[-1]}
                        fi
                        zle _fzf_complete_git_stash_widget "$query"
                        return
                        ;;
                esac
                ;;
            checkout|show|cherry-pick|rebase|reset|revert|merge)
                if [[ ${#words[@]} > 2 && ${words[-1]} != '**' ]]; then
                    query=${words[-1]}
                fi
                zle _fzf_complete_git_refs_widget "$query"
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
