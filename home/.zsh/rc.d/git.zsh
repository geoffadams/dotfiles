if ! (( $+commands[git] )) || ! (( $+commands[fzf] )); then
    return
fi

# ── pickers ────────────────────────────────────────────────────────────────────

_fzf_git_modified_files() {
    local preview
    preview='
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
        --bind 'ctrl-/:toggle-preview'
}

_fzf_git_stashes() {
    git -C . rev-parse --git-dir &>/dev/null || return 1
    git stash list --format='%gd %s' 2>/dev/null | fzf \
        --ansi \
        --preview 'git stash show -p {1} --color=always | delta' \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        | awk '{print $1}'
}

_fzf_git_commits() {
    git -C . rev-parse --git-dir &>/dev/null || return 1
    git log --oneline --color=always 2>/dev/null | fzf \
        --ansi \
        --preview '
            hash=$(echo {} | awk "{print \$1}")
            echo "commit $hash\n"
            git show --stat --format="Author: %an <%ae>%nDate:   %ad%n%n%s%n%n%b" "$hash" --color=always
        ' \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        | awk '{print $1}'
}

# ── zle widgets ────────────────────────────────────────────────────────────────

_fzf_complete_git_files_widget() {
    _fzf_replace_last_args _fzf_git_modified_files
}
zle -N _fzf_complete_git_files_widget

_fzf_complete_git_stash_widget() {
    _fzf_replace_last_args _fzf_git_stashes
}
zle -N _fzf_complete_git_stash_widget

_fzf_complete_git_commit_widget() {
    _fzf_replace_last_args _fzf_git_commits
}
zle -N _fzf_complete_git_commit_widget

# ── fzf **<Tab> hooks ──────────────────────────────────────────────────────────

_fzf_complete_git() {
    local args=("$@")
    local subcommand
    subcommand=$(echo "${args[@]}" | awk '{for(i=1;i<=NF;i++) if($i!="git") {print $i; exit}}')

    case $subcommand in
        add|update-index|rm|checkout|restore|diff)
            _fzf_complete --multi --ansi \
                --preview '
                    f={}
                    file_status=$(git status --short "$f" 2>/dev/null | cut -c1-2)
                    if [[ $file_status == "??" ]]; then
                        bat --style=numbers --color=always "$f" 2>/dev/null || cat "$f"
                    else
                        git diff --color=always HEAD -- "$f" 2>/dev/null | delta
                    fi
                ' \
                --preview-window 'right:60%:wrap' \
                --bind 'ctrl-/:toggle-preview' \
                -- "$@" < <(
                    {
                        git diff --name-only HEAD 2>/dev/null
                        git ls-files --others --exclude-standard 2>/dev/null
                    } | sort -u
                )
            ;;
        stash)
            local stash_subcmd
            stash_subcmd=$(echo "${args[@]}" | awk '{for(i=1;i<=NF;i++) if($i=="stash") {print $(i+1); exit}}')
            case $stash_subcmd in
                show|drop|pop|apply|branch)
                    _fzf_complete --ansi \
                        --preview 'git stash show -p {1} --color=always | delta' \
                        --preview-window 'right:60%:wrap' \
                        --bind 'ctrl-/:toggle-preview' \
                        -- "$@" < <(git stash list --format='%gd %s' 2>/dev/null)
                    ;;
            esac
            ;;
        show|cherry-pick|rebase|reset|revert)
            _fzf_complete --ansi \
                --preview '
                    hash=$(echo {} | awk "{print \$1}")
                    git show --stat --format="Author: %an <%ae>%nDate:   %ad%n%n%s%n%n%b" "$hash" --color=always
                ' \
                --preview-window 'right:60%:wrap' \
                --bind 'ctrl-/:toggle-preview' \
                -- "$@" < <(git log --oneline --color=always 2>/dev/null)
            ;;
    esac
}

_fzf_complete_git_post() {
    awk '{print $1}'
}
