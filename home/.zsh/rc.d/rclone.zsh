if [[ $(command -v rclone) ]]; then
    eval "$(rclone completion zsh -)"

    if [[ $(command -v op) ]]; then
        export RCLONE_PASSWORD_COMMAND="op read op://Cloud/rclone-config/password"
    fi
fi
