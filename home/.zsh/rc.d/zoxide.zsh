#!/usr/bin/env zsh
if ! (($+commands[zoxide])); then
    return
fi

eval "$(zoxide init zsh)"

if (($+commands[fzf])); then
    # ── picker ─────────────────────────────────────────────────────────────────

    # Builds a two-column fzf list: full path TAB colored display path, heatmapped
    # against the matched set's score range. Reused for the initial list and fzf's reload.
    _zoxide_colorize() {
        local query="$1"
        awk -v home="$HOME" \
            '{ score=$1; path=$0; sub(/^ *[0-9.]+ +/,"",path)
               scores[++k]=score; paths[k]=path
               if (k==1||score>max_s) max_s=score
               if (k==1||score<min_s) min_s=score
             }
             END {
                 for (i=1;i<=k;i++) {
                     t = (max_s==min_s) ? 1 : (scores[i]-min_s)/(max_s-min_s)
                     r = int(113 + t*(74 -113))
                     g = int(113 + t*(222-113))
                     b = int(122 + t*(128-122))
                     d = paths[i]; sub("^"home, "~", d)
                     printf "%s\t%s\t\033[38;2;%d;%d;%dm%s\033[0m\n", scores[i], paths[i], r, g, b, d
                 }
             }' \
            <(zoxide query --list --score "$query" 2>/dev/null)
    }

    _fzf_zoxide_dirs() {
        local query="$1"
        # Serialize _zoxide_colorize for use in fzf's reload subshell
        local inline="function _zoxide_colorize() { $functions[_zoxide_colorize] }; _zoxide_colorize \"\$@\""
        fzf \
            --height=~40% \
            --layout=default \
            --info=inline-right \
            --border=line \
            --ansi \
            --disabled \
            --delimiter "\t" \
            --nth=2 \
            --with-nth=3 \
            --accept-nth=2 \
            --prompt 'z> ' \
            --preview 'tree -C -L 2 --compress=3 {2} 2>/dev/null || gls -1F --color=always {2}' \
            --preview-window 'right:50%:border-line:wrap:noinfo' \
            --bind 'ctrl-/:toggle-preview' \
            --bind "change:reload(zsh -c ${(q)inline} -- {q})" \
            --query "$query" \
            < <(_zoxide_colorize "${query}") |
            cut -f1
    }

    # ── zle widgets ────────────────────────────────────────────────────────────

    _fzf_complete_zoxide_widget() {
        local query
        local words=("${(@Q)${(z)LBUFFER}}")
        if [[ -n $1 ]]; then
            query="$1"
        else
            query="${words[-1]}"
        fi
        local result=$(_fzf_zoxide_dirs "$query") || {
            zle redisplay
            return 0
        }
        [[ -z $result ]] && {
            zle redisplay
            return 0
        }
        if ((${#words} == 1)); then
            LBUFFER="${(q)result}"
        else
            LBUFFER="${LBUFFER% *} ${(q)result}"
        fi
        LBUFFER="${LBUFFER# }"
        zle redisplay
    }
    zle -N _fzf_complete_zoxide_widget
    bindkey '^P' _fzf_complete_zoxide_widget

    _fzf_zoxide_widget() {
        local query
        local words=("${(@Q)${(z)LBUFFER}}")
        if [[ -n $1 ]]; then
            query="$1"
        else
            query="${words[-1]}"
        fi
        local result=$(_fzf_zoxide_dirs "$query") || {
            zle redisplay
            return 0
        }
        [[ -z $result ]] && {
            zle redisplay
            return 0
        }
        LBUFFER="z ${(q)result}"
        zle accept-line
    }
    zle -N _fzf_zoxide_widget
    bindkey '^O' _fzf_zoxide_widget
fi
