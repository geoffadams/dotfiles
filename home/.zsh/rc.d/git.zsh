if ! (( $+commands[git] )) || ! (( $+commands[fzf] )); then
    return
fi

# picker inputs
_git_list_refs() {
    {
        git for-each-ref \
            --color=always \
            --sort=-creatordate \
            --format='%(refname:rstrip=-2)%09%(color:blue)%(refname:short)%(color:reset)%09%(contents:subject)' \
            refs/heads refs/remotes refs/tags \
            2>/dev/null
        git log \
            --color=always \
            --abbrev-commit \
            --pretty='format:commit%x09%C(auto)%h%d%x09%s%Creset' \
            2>/dev/null
    }
}
export _FZF_GIT_LIST_REFS=$(functions _git_list_refs)

_git_list_modified_files() {
    git status --porcelain=2 --no-renames | \
        ggrep -v -e "^#" | \
        gsed "s/^\? /? ?? /" | \
        gsed -r 's/^(.) (.)(.)(( [^ ]+ [[:digit:]]+ [[:digit:]]+ [[:digit:]]+ [[:xdigit:]]+ [[:xdigit:]]+)?) (.+)$/\1\t\6\t\o033\[32m\2\o033\[31m\3\o033\[0m/'
}
export _FZF_GIT_LIST_MODIFIED_FILES=$(functions _git_list_modified_files)

_git_list_unstaged_files() {
    git status --porcelain=2 --no-renames | \
        ggrep -v -e '^#' -e '^. .\.' | \
        gsed 's/^\? /? ?? /' | \
        gsed -r 's/^(.) (.)(.)(( [^ ]+ [[:digit:]]+ [[:digit:]]+ [[:digit:]]+ [[:xdigit:]]+ [[:xdigit:]]+)?) (.+?)$/\1\t\6\t\o033\[32m\2\o033\[31m\3\o033\[0m/'
}
export _FZF_GIT_LIST_UNSTAGED_FILES=$(functions _git_list_unstaged_files)

# picker previews
_fzf_git_preview_ref() {
    local line=("${(@Q)${(z)@}}")
    git show --stat --color=always ${line[2]} 2>/dev/null | head -50
}
export _FZF_GIT_PREVIEW_REF=$(functions _fzf_git_preview_ref)

_fzf_git_preview_file() {
    local line=("${(@Q)${(z)@}}")
    echo $line
    local f
    if [[ ${#line} == 1 ]]; then
        f=$line[1]
        echo "one line: $f"
        bat --style=numbers --color=always "$f" 2>/dev/null || cat "$f" 2>/dev/null || ls -1 "$f"
    elif [[ $line[1] == "?" ]]; then
        f=${line[2,-2]}
        echo "? line: $f"
        bat --style=numbers --color=always "$f" 2>/dev/null || cat "$f" 2>/dev/null || ls -1 "$f"
    else
        f=${line[2,-2]}
        echo "other line: $f"
        git diff --color=always HEAD -- "$f" 2>/dev/null | delta
    fi
}
export _FZF_GIT_PREVIEW_FILE=$(functions _fzf_git_preview_file)

# picker builders
_fzf_bind_preview() {
    "$@" --bind "ctrl-/:toggle-preview"
}
_fzf_bind_git_refs() {
    "$@" --bind "ctrl-r:reload(eval $_FZF_GIT_LIST_REFS && _git_list_refs)+change-prompt(ref> )+change-preview(eval $_FZF_GIT_PREVIEW_REF && _fzf_git_preview_ref {})+change-header(ctrl-f: files)+change-nth(1,2)+change-with-nth({2} {3})"
}
_fzf_bind_git_modified_files() {
    "$@" --bind "ctrl-f:reload(eval $_FZF_GIT_LIST_MODIFIED_FILES && _git_list_modified_files)+change-prompt(modified> )+change-preview(eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {})+change-header(ctrl-r: refs)+change-nth(1)+change-with-nth({3} {2})"
}
_fzf_bind_git_unstaged_files() {
    "$@" --bind "ctrl-f:reload-sync(eval $_FZF_GIT_LIST_UNSTAGED_FILES && _git_list_unstaged_files)+change-prompt(unstaged> )+change-preview(eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {})+change-header(ctrl-r: refs)+change-nth(1)+change-with-nth({3} {2})"
}

_fzf_git_with_preview_ref() {
    _fzf_bind_preview "$@" \
        --preview "eval $_FZF_GIT_PREVIEW_REF && _fzf_git_preview_ref {}" \
        --preview-window 'right:60%:wrap' \
    }
_fzf_git_with_preview_file() {
    _fzf_bind_preview "$@" \
        --preview "eval $_FZF_GIT_PREVIEW_FILE && _fzf_git_preview_file {}" \
        --preview-window 'right:60%:wrap'
}

_fzf_git() {
    git -C . rev-parse --git-dir &>/dev/null || return 1
    fzf \
        --height=60% \
        --layout=reverse \
        --with-shell='zsh -c' \
        --ansi \
        "$@"
}

# pickers
_fzf_git_modified_files() {
    _git_list_modified_files | \
        _fzf_git_with_preview_file \
        _fzf_bind_git_refs \
        _fzf_bind_git_modified_files \
        _fzf_git \
        --multi \
        --delimiter "\t" \
        --prompt 'modified> ' \
        --header 'ctrl-r: refs' \
        --nth=1 \
        --with-nth="{3} {2}" \
        --accept-nth=2 \
        --query "$1"
}

_fzf_git_unstaged_files() {
    _git_list_unstaged_files | \
        _fzf_git_with_preview_file \
        _fzf_bind_git_refs \
        _fzf_bind_git_unstaged_files \
        _fzf_git \
        --multi \
        --delimiter "\t" \
        --prompt 'unstaged> ' \
        --header 'ctrl-r: refs' \
        --nth=1 \
        --with-nth="{3} {2}" \
        --accept-nth=2 \
        --query "$1"
}

_fzf_git_tracked_files() {
    git ls-files 2>/dev/null | \
        _fzf_git_with_preview_file \
        _fzf_git \
        --multi \
        --prompt 'tracked> ' \
        --query "$1"
}

_fzf_git_stashes() {
    git stash list --format='%gd %s' 2>/dev/null | \
        _fzf_bind_preview \
        _fzf_git \
        --delimiter ' ' \
        --prompt 'stash> ' \
        --preview "git stash show -p {1} --color=always | delta" \
        --preview-window 'right:60%:wrap' \
        --query "$1"
}

_fzf_git_refs() {
    _git_list_refs | \
        _fzf_git_with_preview_ref \
        _fzf_bind_git_refs \
        _fzf_bind_git_modified_files \
        _fzf_git \
        --delimiter "\t" \
        --prompt 'ref> ' \
        --header 'ctrl-f: modified' \
        --nth=1,2 \
        --with-nth="{2} {3}" \
        --accept-nth=2 \
        --query "$1"
}

# picker zle widgets
_fzf_complete_git_files_widget() {
    _fzf_replace_last_args _fzf_git_modified_files "$1"
}
zle -N _fzf_complete_git_files_widget

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
    local subcmd=$(
        echo "${args[@]}" \
            | awk '{for(i=1;i<=NF;i++) if($i!="git") {print $i; exit}}'
    )

    # '--' after the subcommand means everything following is a file path
    if (( ${args[(I)--]} >= 3 )); then
        _fzf_git_modified_files
        return
    fi

    case $subcmd in
        restore|diff)
            _fzf_git_modified_files
            ;;
        add)
            _fzf_git_unstaged_files
            ;;
        rm)
            _fzf_git_tracked_files
            ;;
        stash)
            local stash_subcmd=$(
                echo "${args[@]}" \
                    | awk '{for(i=1;i<=NF;i++) if($i!="git" && $i!="stash") {print $i; exit}}'
            )
            case $stash_subcmd in
                show|drop|pop|apply|branch)
                    _fzf_git_stashes
                    ;;
            esac
            ;;
        checkout|show|cherry-pick|rebase|reset|revert|merge)
            _fzf_git_refs
            ;;
    esac
}

