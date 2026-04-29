if (( $+commands[rclone] )); then
    eval "$(rclone completion zsh -)"

    if (( $+commands[op] )); then
        export RCLONE_PASSWORD_COMMAND="op read op://Cloud/rclone-config/password"
    fi
fi
