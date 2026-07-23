#!/usr/bin/env zsh
if ! (($+commands[git])) || ! (($+commands[fzf])); then
    return
fi

# picker inputs
_git_list_refs() {
    {
        git for-each-ref \
            --color=always \
            --sort=-creatordate \
            --format='%(refname:rstrip=-2)%09-%09%(color:blue)%(refname:short)%(color:reset)%09%(contents:subject)' \
            refs/heads refs/remotes refs/tags \
            2>/dev/null
        git log \
            --color=always \
            --abbrev-commit \
            --pretty='format:commit%x09-%x09%C(auto)%h%d%x09%s%Creset' \
            2>/dev/null
    }
}
export _FZF_GIT_LIST_REFS=$(functions _git_list_refs)

_git_list_all_files() {
    {
        _git_list_modified_files --untracked-files=all $@
        _git_list_unstaged_files --untracked-files=all $@
        _git_list_untracked_files $@
        _git_list_tracked_files $@
    } | sort -s -k 3 -u
}

_git_list_tracked_files() {
    git ls-files -t |
        gsed -r 's/^(.) (.+)$/\1\t\o033\[90m--\o033\[0m\t\2/'
}
export _FZF_GIT_LIST_TRACKED_FILES=$(functions _git_list_tracked_files)

_git_list_untracked_files() {
    git ls-files -t --others --exclude-standard |
        gsed -r 's/^(.) (.+)$/\1\t??\t\2/'
}
export _FZF_GIT_LIST_UNTRACKED_FILES=$(functions _git_list_untracked_files)

_git_list_modified_files() {
    git status --porcelain=2 --no-renames $@ |
        ggrep -v -e "^#" |
        gsed "s/^\? /? ?? /" |
        gsed -r 's/^(.) (.)(.)(( [^ ]+ [[:digit:]]+ [[:digit:]]+ [[:digit:]]+ [[:xdigit:]]+ [[:xdigit:]]+)?) (.+)$/\1\t\o033\[32m\2\o033\[31m\3\o033\[0m\t\6/'
}
export _FZF_GIT_LIST_MODIFIED_FILES=$(functions _git_list_modified_files)

_git_list_unstaged_files() {
    git status --porcelain=2 --no-renames $@ |
        ggrep -v -e '^#' -e '^. .\.' |
        gsed 's/^\? /? ?? /' |
        gsed -r 's/^(.) (.)(.)(( [^ ]+ [[:digit:]]+ [[:digit:]]+ [[:digit:]]+ [[:xdigit:]]+ [[:xdigit:]]+)?) (.+?)$/\1\t\o033\[32m\2\o033\[31m\3\o033\[0m\t\6/'
}
export _FZF_GIT_LIST_UNSTAGED_FILES=$(functions _git_list_unstaged_files)

export _FZF_GIT_LIST_ALL_FILES=$(functions _git_list_all_files _git_list_modified_files _git_list_unstaged_files _git_list_untracked_files _git_list_tracked_files)

# picker previews
_fzf_git_preview_ref() {
    local line=("${(@Q)${(z)@}}")
    git show --stat --color=always ${line[3]} 2>/dev/null | head -50
}
export _FZF_GIT_PREVIEW_REF=$(functions _fzf_git_preview_ref)

_fzf_git_preview_file() {
    local line=("${(@Q)${(z)@}}")
    local f=${line[3,-1]}

    if [[ $line[1] == "?" ]]; then
        if [[ $f[-1] == "/" ]]; then
            git ls-files --others --exclude-standard -z "$f" | xargs -0 -n 1 delta --paging never /dev/null
        else
            git diff --color=always --no-index -- /dev/null "$f" | delta --file-style "omit" --paging never
        fi
    else
        git diff --color=always HEAD -- "$f" 2>/dev/null | delta --file-style "omit" --paging never
    fi
}
export _FZF_GIT_PREVIEW_FILE=$(functions _fzf_git_preview_file)

# picker builders
_fzf_bind_preview() {
    "$@" --bind "ctrl-/:toggle-preview"
}
_fzf_bind_git_refs() {
    "$@" --bind "ctrl-r:reload(eval $_FZF_GIT_LIST_REFS && _git_list_refs)+change-prompt(ref> )+change-preview(eval $_FZF_GIT_PREVIEW_REF && _fzf_git_preview_ref {})+change-nth(1,2)+change-with-nth({3} {4})"
}
_fzf_bind_git_all_files() {
    "$@" --bind "ctrl-f:reload(eval $_FZF_GIT_LIST_ALL_FILES && _git_list_all_files)+change-prompt(files> )+change-preview(eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {})+change-nth(1)+change-with-nth({2} {3})"
}
_fzf_bind_git_tracked_files() {
    "$@" --bind "ctrl-t:reload(eval $_FZF_GIT_LIST_TRACKED_FILES && _git_list_tracked_files)+change-prompt(tracked> )+change-preview(eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {})+change-nth(1)+change-with-nth({2} {3})"
}
_fzf_bind_git_modified_files() {
    "$@" --bind "ctrl-o:reload(eval $_FZF_GIT_LIST_MODIFIED_FILES && _git_list_modified_files)+change-prompt(modified> )+change-preview(eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {})+change-nth(1)+change-with-nth({2} {3})"
}
_fzf_bind_git_unstaged_files() {
    "$@" --bind "ctrl-u:reload(eval $_FZF_GIT_LIST_UNSTAGED_FILES && _git_list_unstaged_files)+change-prompt(unstaged> )+change-preview(eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {})+change-nth(1)+change-with-nth({2} {3})"
}

_fzf_git_with_preview_ref() {
    _fzf_bind_preview "$@" \
        --preview "eval $_FZF_GIT_PREVIEW_REF && _fzf_git_preview_ref {}" \
        --preview-window 'right:60%:border-line:wrap'
}
_fzf_git_with_preview_file() {
    _fzf_bind_preview "$@" \
        --preview "eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {}" \
        --preview-window 'right:60%:border-line:wrap'
}

_fzf_git() {
    git -C . rev-parse --git-dir &>/dev/null || return 1
    fzf \
        --height=60% \
        --layout=reverse \
        --info=inline-right \
        --border=line \
        --with-shell='zsh -c' \
        --ansi \
        "$@"
}

# pickers
_fzf_git_files() {
    _git_list_all_files |
        _fzf_git_with_preview_file \
            _fzf_bind_git_refs \
            _fzf_bind_git_all_files \
            _fzf_bind_git_modified_files \
            _fzf_bind_git_unstaged_files \
            _fzf_bind_git_tracked_files \
            _fzf_git \
            --multi \
            --delimiter "\t" \
            --prompt 'files> ' \
            --header 'm[^o]dified [^u]nstaged [^f]iles [^t]racked [^r]efs' \
            --nth=1 \
            --with-nth="{2} {3}" \
            --accept-nth=3 \
            --query "$1"
}

_fzf_git_modified_files() {
    _git_list_modified_files |
        _fzf_git_with_preview_file \
            _fzf_bind_git_refs \
            _fzf_bind_git_all_files \
            _fzf_bind_git_modified_files \
            _fzf_bind_git_unstaged_files \
            _fzf_bind_git_tracked_files \
            _fzf_git \
            --multi \
            --delimiter "\t" \
            --prompt 'modified> ' \
            --header 'm[^o]dified [^u]nstaged [^f]iles [^t]racked [^r]efs' \
            --nth=1 \
            --with-nth="{2} {3}" \
            --accept-nth=3 \
            --query "$1"
}

_fzf_git_unstaged_files() {
    _git_list_unstaged_files |
        _fzf_git_with_preview_file \
            _fzf_bind_git_refs \
            _fzf_bind_git_all_files \
            _fzf_bind_git_modified_files \
            _fzf_bind_git_unstaged_files \
            _fzf_bind_git_tracked_files \
            _fzf_git \
            --multi \
            --delimiter "\t" \
            --prompt 'unstaged> ' \
            --header 'm[^o]dified [^u]nstaged [^f]iles [^t]racked [^r]efs' \
            --nth=1 \
            --with-nth="{2} {3}" \
            --accept-nth=3 \
            --query "$1"
}

_fzf_git_tracked_files() {
    _git_list_tracked_files |
        _fzf_git_with_preview_file \
            _fzf_bind_git_refs \
            _fzf_bind_git_all_files \
            _fzf_bind_git_modified_files \
            _fzf_bind_git_unstaged_files \
            _fzf_bind_git_tracked_files \
            _fzf_git \
            --multi \
            --delimiter "\t" \
            --prompt 'tracked> ' \
            --header 'm[^o]dified [^u]nstaged [^f]iles [^t]racked [^r]efs' \
            --nth=1 \
            --with-nth="{2} {3}" \
            --accept-nth=3 \
            --query "$1"
}

_fzf_git_stashes() {
    git stash list --format='%gd %s' 2>/dev/null |
        _fzf_bind_preview \
            _fzf_git \
            --delimiter ' ' \
            --prompt 'stash> ' \
            --preview "git stash show -p {1} --color=always | delta" \
            --preview-window 'right:60%:border-line:wrap' \
            --accept-nth=1 \
            --query "$1"
}

_fzf_git_refs() {
    _git_list_refs |
        _fzf_git_with_preview_ref \
            _fzf_bind_git_refs \
            _fzf_bind_git_all_files \
            _fzf_bind_git_modified_files \
            _fzf_bind_git_unstaged_files \
            _fzf_bind_git_tracked_files \
            _fzf_git \
            --delimiter "\t" \
            --prompt 'ref> ' \
            --header 'm[^o]dified [^u]nstaged [^f]iles [^t]racked [^r]efs' \
            --nth=1,2 \
            --with-nth="{3} {4}" \
            --accept-nth=3 \
            --query "$1"
}

# picker zle widgets
_fzf_complete_git_files_widget() {
    _fzf_replace_last_args _fzf_git_files "$1"
}
zle -N _fzf_complete_git_files_widget

_fzf_complete_git_modified_files_widget() {
    _fzf_replace_last_args _fzf_git_modified_files "$1"
}
zle -N _fzf_complete_git_modified_files_widget

_fzf_complete_git_tracked_files_widget() {
    _fzf_replace_last_args _fzf_git_tracked_files "$1"
}
zle -N _fzf_complete_git_tracked_files_widget

_fzf_complete_git_unstaged_files_widget() {
    _fzf_replace_last_args _fzf_git_unstaged_files "$1"
}
zle -N _fzf_complete_git_unstaged_files_widget

_fzf_complete_git_stash_widget() {
    _fzf_replace_last_args _fzf_git_stashes "$1"
}
zle -N _fzf_complete_git_stash_widget

_fzf_complete_git_refs_widget() {
    _fzf_replace_last_args _fzf_git_refs "$1"
}
zle -N _fzf_complete_git_refs_widget

# fzf hooks
_fzf_complete_git() {
    local args=("$@")
    local subcmd=$args[2]

    # '--' after the subcommand means everything following is a file path
    if ((${args[(I)\-\-]} >= 3)); then
        _fzf_git_files
        return
    fi

    case $subcmd in
    restore | diff)
        _fzf_git_modified_files
        return
        ;;
    add)
        _fzf_git_unstaged_files
        return
        ;;
    rm)
        _fzf_git_tracked_files
        return
        ;;
    checkout | show | cherry-pick | rebase | reset | revert | merge)
        _fzf_git_refs
        return
        ;;
    stash)
        local stash_subcmd=$args[3]
        case $stash_subcmd in
        show | drop | pop | apply | branch)
            _fzf_git_stashes
            return
            ;;
        esac
        ;;
    esac

    _fzf_git_files
}
