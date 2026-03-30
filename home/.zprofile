if has_brew; then
    export BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix)

    path=(${BREW_PREFIX}/bin $path)
    path=(${BREW_PREFIX}/sbin $path)

    export BREW_ZSH_SHARE_PREFIX=${BREW_PREFIX}/share

    HELPDIR=${BREW_ZSH_SHARE_PREFIX}/zsh/help
    unalias run-help 2>/dev/null
    autoload run-help
fi

# load additional config
for f in $PERSONAL_ZSH/profile.d/*.zsh(N); do
    . $f
done
