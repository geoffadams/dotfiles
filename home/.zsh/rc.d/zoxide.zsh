if ! (( $+commands[zoxide] )); then
    return
fi

eval "$(zoxide init zsh)"

if (( $+commands[fzf] )); then
    # ── picker ─────────────────────────────────────────────────────────────────

    _fzf_zoxide_dirs() {
        zoxide query --list 2>/dev/null \
            | awk -v home="$HOME" '{d=$0; sub("^" home, "~", d); print $0 "\t" d}' \
            | fzf \
                --ansi \
                --with-nth=2 \
                --preview 'tree -C -L 2 {1} 2>/dev/null || ls -1F --color=always {1}' \
                --preview-window 'right:50%:wrap' \
                --bind 'ctrl-/:toggle-preview' \
            | cut -f1
    }

    # ── zle widgets ────────────────────────────────────────────────────────────

    _fzf_complete_zoxide_widget() {
        local result
        result=$(_fzf_zoxide_dirs) || { zle redisplay; return 0; }
        [[ -z $result ]] && { zle redisplay; return 0; }
        LBUFFER="${LBUFFER% *} ${(q)result}"
        LBUFFER="${LBUFFER# }"
        zle redisplay
    }
    zle -N _fzf_complete_zoxide_widget

    zoxide_fzf() {
        local selection
        selection=$(_fzf_zoxide_dirs) || { zle redisplay; return 0; }
        [[ -z $selection ]] && { zle redisplay; return 0; }
        LBUFFER="z ${(q)selection}"
        zle accept-line
    }
    zle -N zoxide_fzf
    bindkey '^O' zoxide_fzf

    # ── fzf **<Tab> hook ───────────────────────────────────────────────────────

    _fzf_complete_z() {
        _fzf_complete --ansi \
            --preview 'tree -C -L 2 {} 2>/dev/null || ls -1F --color=always {}' \
            --preview-window 'right:50%:wrap' \
            --bind 'ctrl-/:toggle-preview' \
            -- "$@" < <(zoxide query --list 2>/dev/null)
    }
fi
