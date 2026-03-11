PERSONAL_ZSH=$HOME/.zsh

typeset -U path
path=(${HOME}/.local/bin $path)

export HISTSIZE=100000
export SAVEHIST=100000

# OS detection
is_linux() { [[ $(uname) == "Linux" ]] }
is_mac() { [[ $(uname) == "Darwin" ]] }

# Homebrew setup
has_brew() { [[ $(command -v "/opt/homebrew/bin/brew") ]] }

export ZSH_SHARE_PREFIX=/usr/share
if [[ has_brew ]]; then
    export BREW_PREFIX=$(/opt/homebrew/bin/brew --prefix)

    path=(${BREW_PREFIX}/bin $path)
    path=(${BREW_PREFIX}/sbin $path)

    export ZSH_SHARE_PREFIX=${BREW_PREFIX}/share

    HELPDIR=${BREW_PREFIX}/share/zsh/help
    unalias run-help 2>/dev/null
    autoload run-help
fi

# load additional config
for f in $PERSONAL_ZSH/env.d/*.zsh(N); do
    . $f
done

# load system-local config
for f in $PERSONAL_ZSH/env.private.d/*.zsh(N); do
    . $f
done
