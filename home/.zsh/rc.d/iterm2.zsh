if [[ -n "$ITERM_SESSION_ID" ]]; then
    # iTerm2 shell integrations
    include "${HOME}/.iterm2_shell_integration.zsh"

    tab-color() {
        echo -ne "\033]6;1;bg;red;brightness;$1\a"
        echo -ne "\033]6;1;bg;green;brightness;$2\a"
        echo -ne "\033]6;1;bg;blue;brightness;$3\a"
    }
    tab-reset() {
        echo -ne "\033]6;1;bg;*;default\a"
    }

    # Change the color of the tab when using SSH
    # reset the color after the connection closes
    color-ssh() {
        trap "tab-reset" INT EXIT
        tab-color 133 153 0
        ssh $*
    }
    compdef _ssh color-ssh=ssh

    alias ssh="color-ssh"

    # allow path names to be a little longer
    ZSH_THEME_TERM_TAB_TITLE_IDLE="%100<..<%~%<<"
fi
