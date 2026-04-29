if ! (( $+commands[zoxide] )); then
    return
fi

eval "$(zoxide init zsh)"

if (( $+commands[fzf] )); then
    # ── picker ─────────────────────────────────────────────────────────────────

    # Generates a two-column fzf-ready list: full-path TAB colored-display-path.
    # Colors are a heatmap relative to the score range of the matched set only.
    # Called directly for the initial list and serialized into fzf's reload binding.
    _zoxide_colorize() {
        local query="$1"
        local raw all_paths filtered
        raw=$(zoxide query --list --score 2>/dev/null)
        [[ -z "$raw" ]] && return
        all_paths=$(printf '%s\n' "$raw" | awk '{sub(/^ *[0-9.]+ +/,""); print}')
        if [[ -n "$query" ]]; then
            filtered=$(printf '%s\n' "$all_paths" | fzf --filter="$query" --no-sort 2>/dev/null)
        else
            filtered="$all_paths"
        fi
        [[ -z "$filtered" ]] && return
        awk -v home="$HOME" \
            'NR==FNR { vis[$0]=1; next }
             { score=$1; path=$0; sub(/^ *[0-9.]+ +/,"",path)
               if (path in vis) {
                   scores[++k]=score; paths[k]=path
                   if (k==1||score>max_s) max_s=score
                   if (k==1||score<min_s) min_s=score
               }
             }
             END {
                 for (i=1;i<=k;i++) {
                     t = (max_s==min_s) ? 1 : (scores[i]-min_s)/(max_s-min_s)
                     r = int(113 + t*(74 -113))
                     g = int(113 + t*(222-113))
                     b = int(122 + t*(128-122))
                     d = paths[i]; sub("^"home,"~",d)
                     printf "%s\t\033[38;2;%d;%d;%dm%s\033[0m\n",paths[i],r,g,b,d
                 }
             }' \
            <(printf '%s\n' "$filtered") \
            <(printf '%s\n' "$raw")
    }

    _fzf_zoxide_dirs() {
        # Serialize _zoxide_colorize for use in fzf's reload subshell
        local inline="function _zoxide_colorize() { $functions[_zoxide_colorize] }; _zoxide_colorize \"\$@\""
        fzf \
            --ansi \
            --disabled \
            --with-nth=2 \
            --preview 'tree -C -L 2 {1} 2>/dev/null || ls -1F --color=always {1}' \
            --preview-window 'right:50%:wrap' \
            --bind 'ctrl-/:toggle-preview' \
            --bind "change:reload(zsh -c ${(q)inline} -- {q})" \
            < <(_zoxide_colorize "") \
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
