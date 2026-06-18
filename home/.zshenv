PERSONAL_ZSH=$HOME/.zsh

typeset -U path
path=(${HOME}/.local/bin $path)

export LANG=en_GB.UTF-8
export LANGUAGE=en_GB:en
export LC_ALL=en_GB.UTF-8
export TERM=xterm-256color

# OS detection
is_linux() { [[ $(uname) == "Linux" ]] }
is_mac() { [[ $(uname) == "Darwin" ]] }

# Homebrew setup
has_brew() { [[ -x /opt/homebrew/bin/brew ]] }


# load additional config
for f in $PERSONAL_ZSH/env.d/*.zsh(N); do
    . $f
done

# load system-local config
for f in $PERSONAL_ZSH/env.private.d/*.zsh(N); do
    . $f
done
