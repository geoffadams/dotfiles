#!/usr/bin/env zsh
if ! (($+commands[fzf])); then
    return
fi

source <(fzf --zsh)

# base fzf config
export FZF_CTRL_R_OPTS="--scheme history
    --layout=default
    --info=inline-right
    --border=line
    --ansi
    --preview 'echo -ne {} | cut -f2 | bat -f --wrap never -l sh --style=plain'
    --preview-window down:3:border-line:wrap:noinfo
    --bind '?:toggle-preview'"

if (($+commands[fd])); then
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }
fi

# fzf helpers

# Appends fzf selection(s) to the current line buffer, replacing the last word.
_fzf_replace_last_args() {
    local src_fn=$1
    local src_query=$2
    local result
    result=$($src_fn $src_query) || {
        zle redisplay
        return 0
    }
    [[ -z $result ]] && {
        zle redisplay
        return 0
    }
    local quoted
    quoted=$(printf '%q ' ${(f)result})
    LBUFFER="${LBUFFER% *} $quoted"
    LBUFFER="${LBUFFER# }"
    zle redisplay
}

# fzf-driven tab completions

_fzf_smart_tab_query() {
    [[ ${#@} > 0 && $@[-1] != ('**'|'--') ]] && echo $@[-1]
}

_fzf_smart_tab() {
    local words=("${(@Q)${(z)LBUFFER}}")

    # let normal completion handle options; '--' is only a file delimiter when followed by a space
    [[ ${words[-1]} == -* ]] && [[ ${words[-1]} != '--' || $LBUFFER[-1] != ' ' ]] && {
        zle expand-or-complete
        return
    }

    local cmd=$words[1]
    shift words
    if (($+commands[git])) && [[ $cmd == "git" ]]; then
        # fall back to default completion for partial git subcommands
        if [[ ${#words} < 1 ]] || [[ ${#words} == 1 && $LBUFFER[-1] != ' ' ]]; then
            zle expand-or-complete
            return
        fi

        # '--' after the subcommand means everything following is a file path
        # (I) returns the index of the last match, or 0 if not found
        if ((${words[(I)\-\-]} > 0)); then
            zle _fzf_complete_git_files_widget "$(_fzf_smart_tab_query $words)"
            return
        fi

        local subcmd=$words[1]
        shift words
        case $subcmd in
        restore | diff)
            zle _fzf_complete_git_modified_files_widget "$(_fzf_smart_tab_query $words)"
            return
            ;;
        add)
            zle _fzf_complete_git_unstaged_files_widget "$(_fzf_smart_tab_query $words)"
            return
            ;;
        rm)
            zle _fzf_complete_git_tracked_files_widget "$(_fzf_smart_tab_query $words)"
            return
            ;;
        checkout | show | cherry-pick | rebase | reset | revert | merge)
            zle _fzf_complete_git_refs_widget "$(_fzf_smart_tab_query $words)"
            return
            ;;
        stash)
            local stash_subcmd=$words[1]
            shift words
            case $stash_subcmd in
            show | drop | pop | apply | branch)
                zle _fzf_complete_git_stash_widget "$(_fzf_smart_tab_query $words)"
                return
                ;;
            esac
            ;;
        esac

        zle _fzf_complete_git_files_widget "$(_fzf_smart_tab_query $words)"
        return
    fi

    if (($+commands[zoxide])) && [[ $cmd == "z" || $cmd == "zi" ]]; then
        zle _fzf_complete_zoxide_widget "$(_fzf_smart_tab_query $words)"
        return
    fi

    zle expand-or-complete
}
zle -N _fzf_smart_tab
bindkey '^I' _fzf_smart_tab
