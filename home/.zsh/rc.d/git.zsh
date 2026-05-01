if ! (( $+commands[git] )) || ! (( $+commands[fzf] )); then
    return
fi

# ── pickers ────────────────────────────────────────────────────────────────────

_fzf_git_modified_files() {
    local query="$1"
    local preview='
        f={}
        file_status=$(git status --short "$f" 2>/dev/null | cut -c1-2)
        if [[ $file_status == "??" ]]; then
            echo "--- untracked ---"
            bat --style=numbers --color=always "$f" 2>/dev/null || cat "$f"
        else
            git diff --color=always HEAD -- "$f" 2>/dev/null | delta
        fi
    '
    git -C . rev-parse --git-dir &>/dev/null || return 1
    {
        git diff --name-only HEAD 2>/dev/null
        git ls-files --others --exclude-standard 2>/dev/null
    } | sort -u | fzf \
        --multi \
        --ansi \
        --preview "$preview" \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --query "$query"
}

_fzf_git_stashes() {
    local query="$1"
    local preview='git stash show -p {1} --color=always | delta'
    git -C . rev-parse --git-dir &>/dev/null || return 1
    git stash list --format='%gd %s' 2>/dev/null | fzf \
        --ansi \
        --preview "$preview" \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --query "$query" \
        | awk '{print $1}'
}

_fzf_git_commits() {
    local query="$1"
    local preview='
        hash=$(echo {} | awk "{print \$1}")
        echo "commit $hash\n"
        git show --stat --format="Author: %an <%ae>%nDate:   %ad%n%n%s%n%n%b" "$hash" --color=always
    '
    git -C . rev-parse --git-dir &>/dev/null || return 1
    git log --oneline --color=always 2>/dev/null | fzf \
        --ansi \
        --preview "$preview" \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --query "$query" \
        | awk '{print $1}'
}

# ── zle widgets ────────────────────────────────────────────────────────────────

_fzf_complete_git_files_widget() {
    _fzf_replace_last_args _fzf_git_modified_files "$1"
}
zle -N _fzf_complete_git_files_widget

_fzf_complete_git_stash_widget() {
    _fzf_replace_last_args _fzf_git_stashes "$1"
}
zle -N _fzf_complete_git_stash_widget

_fzf_complete_git_commit_widget() {
    _fzf_replace_last_args _fzf_git_commits "$1"
}
zle -N _fzf_complete_git_commit_widget

# ── fzf **<Tab> hooks ──────────────────────────────────────────────────────────

_fzf_complete_git() {
    local args=("$@")
    local subcmd=$(
        echo "${args[@]}" \
            | awk '{for(i=1;i<=NF;i++) if($i!="git") {print $i; exit}}'
    )

    case $subcmd in
        add|update-index|rm|restore|diff)
            _fzf_git_modified_files
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
        show|cherry-pick|rebase|reset|revert)
            _fzf_git_commits
            ;;
    esac
}

_fzf_complete_git_post() {
    awk '{print $1}'
}
