if ! (( $+commands[git] )) || ! (( $+commands[fzf] )); then
    return
fi

# ── pickers ────────────────────────────────────────────────────────────────────

_fzf_git_modified_files() {
    local query="$1"
    local preview='
        f={1}
        file_status=$(git status --short "$f" 2>/dev/null | cut -c1-2)
        if [[ $file_status == "??" ]]; then
            echo "--- untracked ---"
            bat --style=numbers --color=always "$f" 2>/dev/null || cat "$f"
        else
            git diff --color=always HEAD -- "$f" 2>/dev/null | delta
        fi
    '
    local refs_reload='git for-each-ref --sort=-creatordate --format="%(refname:short)" refs/heads refs/remotes refs/tags 2>/dev/null; git log --oneline --color=always 2>/dev/null'
    local files_reload='{ git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | sort -u | (f=$(cat); [ -n "$f" ] && echo "$f" | xargs ls -t1d 2>/dev/null || true)'
    git -C . rev-parse --git-dir &>/dev/null || return 1
    local files
    files=$(
        { git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | sort -u
    )
    [[ -z "$files" ]] && return 1
    echo "$files" | xargs ls -t1d 2>/dev/null | fzf \
        --height=60% \
        --layout=reverse \
        --multi \
        --ansi \
        --delimiter ' ' \
        --prompt 'file> ' \
        --header 'ctrl-r: refs/commits' \
        --preview "$preview" \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --bind "ctrl-r:reload($refs_reload)+change-prompt(ref> )+change-preview(git show --stat --color=always {1} 2>/dev/null | head -50)+change-header(ctrl-f: files)" \
        --bind "ctrl-f:reload($files_reload)+change-prompt(file> )+change-preview($preview)+change-header(ctrl-r: refs/commits)" \
        --query "$query" \
        | awk '{print $1}'
}

_fzf_git_stashes() {
    local query="$1"
    local preview='git stash show -p {1} --color=always | delta'
    git -C . rev-parse --git-dir &>/dev/null || return 1
    git stash list --format='%gd %s' 2>/dev/null | fzf \
        --height=60% \
        --layout=reverse \
        --ansi \
        --delimiter ' ' \
        --preview "$preview" \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --query "$query" \
        | awk '{print $1}'
}

_fzf_git_refs() {
    local query="$1"
    local files_reload='{ git diff --name-only HEAD 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | sort -u | (f=$(cat); [ -n "$f" ] && echo "$f" | xargs ls -t1d 2>/dev/null || true)'
    local refs_reload='git for-each-ref --sort=-creatordate --format="%(refname:short)" refs/heads refs/remotes refs/tags 2>/dev/null; git log --oneline --color=always 2>/dev/null'
    local file_preview='git diff --color=always HEAD -- {1} 2>/dev/null | delta'
    git -C . rev-parse --git-dir &>/dev/null || return 1
    {
        git for-each-ref --sort=-creatordate --format='%(refname:short)' refs/heads refs/remotes refs/tags 2>/dev/null
        git log --oneline --color=always 2>/dev/null
    } | fzf \
        --height=60% \
        --layout=reverse \
        --ansi \
        --delimiter ' ' \
        --prompt 'ref> ' \
        --header 'ctrl-f: files' \
        --preview 'git show --stat --color=always {1} 2>/dev/null | head -50' \
        --preview-window 'right:60%:wrap' \
        --bind 'ctrl-/:toggle-preview' \
        --bind "ctrl-f:reload($files_reload)+change-prompt(file> )+change-preview($file_preview)+change-header(ctrl-r: refs/commits)" \
        --bind "ctrl-r:reload($refs_reload)+change-prompt(ref> )+change-preview(git show --stat --color=always {1} 2>/dev/null | head -50)+change-header(ctrl-f: files)" \
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

_fzf_complete_git_refs_widget() {
    _fzf_replace_last_args _fzf_git_refs "$1"
}
zle -N _fzf_complete_git_refs_widget

# ── fzf **<Tab> hooks ──────────────────────────────────────────────────────────

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
        checkout|show|cherry-pick|rebase|reset|revert|merge)
            _fzf_git_refs
            ;;
    esac
}

_fzf_complete_git_post() {
    awk '{print $1}'
}
