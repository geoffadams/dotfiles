if [[ $(command -v fzf) ]]; then
    source <(fzf --zsh)

    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"

    if [[ $(command -v fd) ]]; then
        # fd for path completion
        _fzf_compgen_path() {
            fd --hidden --follow --exclude ".git" . "$1"
        }

        # fd for file completion
        _fzf_compgen_dir() {
            fd --type d --hidden --follow --exclude ".git" . "$1"
        }
    fi
fi
