PERSONAL_ZSH=$HOME/.zsh

typeset -U path
path=(${HOME}/.local/bin $path)

HISTSIZE=100000
SAVEHIST=100000

PAGER=bat
MANPAGER="nvim +Man!"
EDITOR=nvim

# OS detection
os_name=$(uname)
export IS_LINUX=0
[[ "$os_name" == 'Linux' ]] && export IS_LINUX=1
export IS_MAC=0
[[ "$os_name" == 'Darwin' ]] && export IS_MAC=1
unset os_name
is_mac() { [[ $IS_MAC -eq 1 ]]; }

# Homebrew setup
export IS_HOMEBREW=0
has_brew() { [[ $IS_HOMEBREW -eq 1 ]]; }

export ZSH_SHARE_PREFIX=/usr/share
if [ -f "/opt/homebrew/bin/brew" ]; then
    export IS_HOMEBREW=1
    export BREW_PREFIX="/opt/homebrew"

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
